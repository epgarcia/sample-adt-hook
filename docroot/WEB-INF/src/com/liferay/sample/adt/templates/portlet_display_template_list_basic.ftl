<#if entries?has_content>
	<#list entries as curEntry>
		<#assign assetRenderer = curEntry.getAssetRenderer() />

		<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />

		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry) />

		<div class="asset-abstract">
			<h3 class="asset-title">
				${curEntry_index +1}.&nbsp;<a href="${viewURL}">${entryTitle}</a>
			</h3>
		</div>
	</#list>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>