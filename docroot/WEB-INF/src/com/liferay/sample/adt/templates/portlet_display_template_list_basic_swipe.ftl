<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />
<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />

<#if entries?has_content>
	<#assign isMobile = browserSniffer.isMobile(request) />

	<div id="<@liferay_portlet.namespace />swipe">
		<#list entries as curEntry>
			<#assign assetRenderer = curEntry.getAssetRenderer() />

			<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />

			<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry) />

			<#if assetLinkBehavior != "showFullContent">
				<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
			</#if>

			<div class="asset-abstract">
				<div class="lfr-meta-actions asset-actions">
					<@getEditIcon />
				</div>

				<h3 class="asset-title w90">
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
	</div>

	<#if isMobile>
		<@aui["script"] use="node-base,node-event-delegate,transition,event-move">
			var MIN_SWIPE = 10;

			A.one('#<@liferay_portlet.namespace />swipe').delegate(
				'gesturemovestart',
				function(event) {
					var currentTarget = event.currentTarget;
					var target = event.target;

					if (!target.hasClass("edit-asset")) {
						event.container.all('.edit-asset').addClass('hide');

						currentTarget.setData('swipeStart', event.pageX);

						currentTarget.once(
							'gesturemoveend',
							function(event) {
								var swipeStart = currentTarget.getData('swipeStart');

								var swipeEnd = event.pageX;

								var isSwipeLeft = (swipeStart - swipeEnd) > MIN_SWIPE;

								if (isSwipeLeft) {
									currentTarget.one('.edit-asset').removeClass('hide');
								}
							}
						);
					}
				},
				'.asset-abstract'
			);
		</@>
	</#if>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>

<#macro getEditIcon>
	<#if assetRenderer.hasEditPermission(themeDisplay.getPermissionChecker())>
		<#assign redirectURL = renderResponse.createRenderURL() />

		${redirectURL.setParameter("struts_action", "/asset_publisher/add_asset_redirect")}
		${redirectURL.setWindowState("pop_up")}

		<#assign editPortletURL = assetRenderer.getURLEdit(renderRequest, renderResponse, windowStateFactory.getWindowState("pop_up"), redirectURL)!"" />

		<#if validator.isNotNull(editPortletURL)>
			<#assign title = languageUtil.format(locale, "edit-x", entryTitle) />

			<@aui["a"] href="javascript:Liferay.Util.openWindow({dialog: {width: 960}, id:'" + renderResponse.getNamespace() + "editAsset', title: '" + title + "', uri:'" + htmlUtil.escapeURL(editPortletURL.toString()) + "'});">
				<span class='badge badge-info edit-asset ${isMobile?string("hide","")}'><@liferay_ui["message"] key="edit" /></span>
			</@>
		</#if>
	</#if>
</#macro>