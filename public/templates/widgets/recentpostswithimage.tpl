<div class="recent_posts_with_media" data-numposts="{numPosts}" data-cid="{cid}">
	<!-- IMPORT partials/posts.tpl -->
</div>

<script>
'use strict';
/* globals app, socket, translator, templates*/
(function() {

	function triggerMasonry() {
		console.log('trigger Masonry');
		var msnry = new Masonry( '.recent_posts_with_media', {
			itemSelector: '.recent_post_with_media',
			columnWidth: 260,
			fitWidth: true
		});
	}
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
	function onLoad() {
		console.log('onLoad');
		[].forEach.call( document.images, function( img ) {
			img.addEventListener('load', triggerMasonry, false );
		});
		triggerMasonry();
		postHoverHook();
	}

	if (window.jQuery) {
		// page loaded, switching to this view from other view
		onLoad();
	} else {
		window.addEventListener('load', onLoad);
	}
	// layout Masonry after each image loads
	// imagesLoaded('.recent_post_with_media img', function() {
	// 	console.log('image loaded');
	// 	var msnry = new Masonry( '.recent_posts_with_media', {
	// 		itemSelector: '.recent_post_with_media',
	// 		columnWidth: 260,
	// 		fitWidth: true
	// 	});
	// });

})();
</script>
