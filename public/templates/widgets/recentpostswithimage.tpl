<div class="recent_posts_with_media" data-numposts="{numPosts}" data-cid="{cid}">
	<!-- IMPORT partials/posts.tpl -->
</div>

<script>
'use strict';
/* globals app, socket, translator, templates*/
(function() {
	function onLoad() {
		var replies = $('#recent_posts');

		app.createUserTooltips();
		processHtml(replies);

		var recentPostsWidget = app.widgets.recentPosts;
		var numPosts = parseInt(replies.attr('data-numposts'), 10) || 10;

		if (!recentPostsWidget) {
			recentPostsWidget = {};
			recentPostsWidget.onNewPost = function(data) {

				var cid = replies.attr('data-cid');
				var recentPosts = $('#recent_posts');
				if (!recentPosts.length) {
					return;
				}

				if (cid && parseInt(cid, 10) !== parseInt(data.posts[0].topic.cid, 10)) {
					return;
				}

				app.parseAndTranslate('partials/posts', {
					relative_path: config.relative_path,
					posts: data.posts
				}, function(html) {
					processHtml(html);

					html.hide()
						.prependTo(recentPosts)
						.fadeIn();

					app.createUserTooltips();
					if (recentPosts.children().length > numPosts) {
						recentPosts.children().last().remove();
					}
				});
			};

			app.widgets.recentPosts = recentPostsWidget;
			socket.on('event:new_post', app.widgets.recentPosts.onNewPost);
		}

		function processHtml(html) {
			app.replaceSelfLinks(html.find('a'));

			html.find('img:not(.not-responsive)').addClass('img-responsive');
			html.find('span.timeago').timeago();
		}
	}


	if (window.jQuery) {
		onLoad();
	} else {
		window.addEventListener('load', onLoad);
	}

	// layout Masonry after each image loads
	imagesLoaded('.recent_posts_with_media', function() {
		var msnry = new Masonry( '.recent_posts_with_media', {
			itemSelector: '.recent_post_with_media',
			columnWidth: 260
		});
	});

	function postHoverHook() {
		if (window.jQuery) {
			$('.recent_post_with_media').mouseenter(function(){
				$(this).find('.recent-post-title').show();
			})
			$('.recent_post_with_media').mouseleave(function(){
				$(this).find('.recent-post-title').hide();
			})
			return;
		}
		setTimeout(function(){postHoverHook();}, 500);
	}
	postHoverHook();

})();
</script>
