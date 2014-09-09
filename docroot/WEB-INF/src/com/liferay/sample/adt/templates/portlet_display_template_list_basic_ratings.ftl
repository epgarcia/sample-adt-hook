<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />

<#if entries?has_content>
	<#list entries as curEntry>
		<#assign assetRenderer = curEntry.getAssetRenderer() />

		<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />

		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry) />

		<#if assetLinkBehavior != "showFullContent">
			<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
		</#if>

		<div class="asset-abstract">
			<h3 class="asset-title">
				${curEntry_index +1}.&nbsp;<a href="${viewURL}">${entryTitle}</a>
			</h3>
		</div>

		<#if (enableRatings == "true")>
			<div class="asset-ratings">
				<@liferay_ui["ratings"]
					className=curEntry.getClassName()
					classPK=curEntry.getClassPK()
				/>
			</div>
		</#if>
	</#list>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>