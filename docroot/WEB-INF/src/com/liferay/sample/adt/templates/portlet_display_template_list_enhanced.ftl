<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />
<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />

<#if entries?has_content>
	<#list entries as curEntry>
		<#assign assetRenderer = curEntry.getAssetRenderer() />

		<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />

		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry) />

		<#if assetLinkBehavior != "showFullContent">
			<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
		</#if>

		<div class="asset-abstract container-fluid">
			<div class="index span1" style="text-align:center">
				<h1>${curEntry_index +1}<h1>
			</div>

			<div class="asset-image span2">
				<img src="${assetRenderer.getThumbnailPath(renderRequest)}" />
			</div>

			<div class="asset-content span7">
				<h3 class="asset-title" style="margin:0 0 10px;line-height:25px;border:0">
					<a href="${viewURL}">${entryTitle}</a>
				</h3>

				<div class="asset-summary">
					${htmlUtil.escape(stringUtil.shorten(assetRenderer.getSummary(locale), 50))}

					<a href="${viewURL}"><@liferay.language key="read-more" /><span class="hide-accessible"><@liferay.language key="about" />${entryTitle}</span> &raquo;</a>
				</div>
			</div>
		</div>
	</#list>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>