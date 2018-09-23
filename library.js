"use strict";

var async = module.parent.require('async');
var nconf = module.parent.require('nconf');
var validator = module.parent.require('validator');

var db = module.parent.require('./database');
var categories = module.parent.require('./categories');
var user = module.parent.require('./user');
var plugins = module.parent.require('./plugins');
var topics = module.parent.require('./topics');
var posts = module.parent.require('./posts');
var groups = module.parent.require('./groups');
var utils = module.parent.require('./utils');

var benchpressjs = module.parent.require('benchpressjs');

var app;

var Widget = module.exports;
const searchRegex = /\/assets\/uploads\/files\/([^\s")]+\.?[\w]*)/g;

Widget.init = function(params, callback) {
	app = params.app;

	callback();
};

function getCidsArray(widget) {
	var cids = widget.data.cid || '';
	cids = cids.split(',');
	cids = cids.map(function (cid) {
		return parseInt(cid, 10);
	}).filter(Boolean);
	return cids;
}

function isVisibleInCategory(widget) {
	var cids = getCidsArray(widget);
	return !(cids.length && (widget.templateData.template.category || widget.templateData.template.topic) && cids.indexOf(parseInt(widget.templateData.cid, 10)) === -1);
}

Widget.renderRecentPostsWithImageWidget = function(widget, callback) {

	var cid = widget.data.cid;
	if (!parseInt(cid, 10)) {
		var match = widget.area.url.match('category/([0-9]+)');
		cid = (match && match.length > 1) ? match[1] : null;
	}
	var numPosts = widget.data.numPosts || 4;
	async.waterfall([
		function (next) {
			if (cid) {
				categories.getRecentReplies(cid, widget.uid, numPosts, next);
			} else {

				posts.getRecentPosts(widget.uid, 0, Math.max(0, numPosts - 1), 'alltime', next);
			}
		},
		function (postsData, next) {
			var postsWithMedia = [];
			// Extract upload file paths from post content
			postsData.forEach(function(post){
				let match = searchRegex.exec(post.content);
				if (match) {
					var firstMedia = (match[0].replace('-resized', ''));
					post.firstMedia = firstMedia;
					postsWithMedia.push(post);
				}
			})

			var data = {
				posts: postsWithMedia,
				numPosts: numPosts,
				cid: cid,
				relative_path: nconf.get('relative_path'),
			};

			app.render('widgets/recentpostswithimage', data, next);
		},
		function (html, next) {
			widget.html = html;
			next(null, widget);
		},
	], callback);
};

Widget.defineWidgets = function(widgets, callback) {
	async.waterfall([
		function(next) {
			async.map([
				{
					widget: "recentpostswithimage",
					name: "Recent Posts With Image",
					description: "Lists the latest posts on your forum.",
					content: 'admin/recentpostswithimage'
				}
			], function(widget, next) {
				app.render(widget.content, {}, function(err, html) {
					widget.content = html;
					next(err, widget);
				});
			}, function(err, _widgets) {
				widgets = widgets.concat(_widgets);
				next(err);
			});
		},
		function(next) {
			db.getSortedSetRevRange('groups:visible:createtime', 0, - 1, next);
		},
		function(groupNames, next) {
			groups.getGroupsData(groupNames, next);
		},
		function(groupsData, next) {
			groupsData = groupsData.filter(Boolean);
			groupsData.forEach(function(group) {
				group.name = validator.escape(String(group.name));
			});
			app.render('admin/groupposts', {groups: groupsData}, function(err, html) {
				widgets.push({
					widget: "groupposts",
					name: "Group Posts",
					description: "Posts made my members of a group",
					content: html
				});
				next(err, widgets);
			});
		}
	], callback);
};
