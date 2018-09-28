<!-- BEGIN topics -->
<div class="recent-topics-topic-wrapper">
	<div class="pull-left hidden-xs username">
		<a href="<!-- IF topics.user.userslug -->{relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->">
			<!-- IF topics.user.picture -->
			<img class="user-avatar" src="{topics.user.picture}" alt="{topics.user.username}" title="{topics.user.username}" />
			<!-- ELSE -->
			<div class="user-icon" style="background-color: {topics.user.icon:bgColor};">{topics.user.icon:text}</div>
			<!-- ENDIF topics.user.picture -->
		</a>
	</div>
<!-- 	<small class="pull-right post-preview-footer">
		<span class="timeago" title="{topics.lastposttimeISO}"></span>
	</small> -->
	<div class="media-body">
		<div class="lv-title" component="topic/header">
			<a href="{relative_path}/topic/{topics.slug}">{topics.title}</a>
		</div>
		<small class="lv-small">
			<span class="hidden-xs">[[global:posts]] <span class="human-readable-number" title="{topics.postcount}"></span> | [[global:views]] <span class="human-readable-number" title="{topics.viewcount}"></span> | </span>
			<strong>{topics.user.username}</strong> <a href="{config.relative_path}/category/{topics.category.slug}">[[global:posted_in, {topics.category.name}]] <i class="fa {topics.category.icon}"></i></a> <span class="timeago" title="{topics.timestampISO}"></span>
		</small>
	</div>
</div>
<!-- END topics -->
