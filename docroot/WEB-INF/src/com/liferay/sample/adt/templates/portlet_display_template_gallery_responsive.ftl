<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#if entries?has_content>
	<div id="<@liferay_portlet.namespace />carousel" style="overflow: hidden; height:1px;">
		<#assign imageMimeTypes = propsUtil.getArray("dl.file.entry.preview.image.mime.types") />

		<#list entries as entry>
			<#if imageMimeTypes?seq_contains(entry.getMimeType()) >
				<div class="carousel-item">
					<img src="${dlUtil.getPreviewURL(entry, entry.getFileVersion(), themeDisplay, "")}" style="width:100%" />
				</div>
			</#if>
		</#list>
	</div>

	<@aui.script use="aui-carousel,event-resize">
		new A.Carousel(
			{
				contentBox: '#<@liferay_portlet.namespace />carousel',
				intervalTime: 2
			}
		).render();

		var updateCarouselHeight = function() {
			var item = A.one('#<@liferay_portlet.namespace />carousel');
			var itemNode = A.one('#<@liferay_portlet.namespace />carousel .carousel-item img');
			var itemHeight = itemNode.getComputedStyle('height');
			item.setStyle('height',itemHeight);
		}

		updateCarouselHeight();
		A.on('windowresize', updateCarouselHeight);
	</@aui.script>
</#if>