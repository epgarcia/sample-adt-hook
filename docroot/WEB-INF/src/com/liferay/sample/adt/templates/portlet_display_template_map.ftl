<#--
Application display templates can be used to modify the look of a
specific application.

Please use the left panel to quickly add commonly used variables.
Autocomplete is also available and can be invoked by typing "${".
-->

<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />
<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />

<#assign jsonArray = jsonFactoryUtil.createJSONArray() />

<#list entries as curEntry>
	<#assign assetRenderer = curEntry.getAssetRenderer() />

	<#assign geolocation = expandoValueLocalService.getData(company.getCompanyId(),curEntry.getClassName(),"CUSTOM_FIELDS","geolocation",curEntry.getClassPK()) />

	<#if validator.isNotNull(geolocation)>
		<#assign geolocationJSON = geolocation?replace("(.*),(.*)", "{\"latitude\":$1,\"longitude\":$2}","r") />

		<#assign jsonObject = jsonFactoryUtil.createJSONObject(geolocationJSON) />

		<@silently jsonObject.put("title", assetRenderer.getTitle(locale)) />

		<#assign entryAbstract>
			<@getAbstract asset = curEntry />
		</#assign>

		<@silently jsonObject.put("infoWindow", entryAbstract) />
		<@silently jsonArray.put(jsonObject) />
	</#if>
</#list>

<#if (jsonArray.length() > 0)>
	<div class="map-canvas" id="<@liferay_portlet.namespace />mapCanvas"></div>

	<style type="text/css">
		#<@liferay_portlet.namespace />assetEntryAbstract {
			min-width: 400px;
			overflow: auto;
		}

		#<@liferay_portlet.namespace />assetEntryAbstract .asset-entry-abstract-image {
			float: left;
			margin-right: 2em;
		}

		#<@liferay_portlet.namespace />assetEntryAbstract .asset-entry-abstract-image img {
			display: block;
		}

		#<@liferay_portlet.namespace />assetEntryAbstract .taglib-icon {
			float: right;
		}

		#<@liferay_portlet.namespace />mapCanvas {
			min-height: 400px;
		}
	</style>

	<link href="${httpUtil.getProtocol(request)}://cdn.leafletjs.com/leaflet-0.7.2/leaflet.css" rel="stylesheet" />

	<script src="${httpUtil.getProtocol(request)}://cdn.leafletjs.com/leaflet-0.7.2/leaflet.js"></script>

	<@aui["script"]>
		(function() {
			var putMarkers = function(map) {
				var bounds;

				L.tileLayer(
					'${httpUtil.getProtocol(request)}://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
					{
						attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
					}
				).addTo(map);

				var points = ${jsonArray};

				var len = points.length;

				if (len) {
					bounds = L.latLngBounds([]);

					for (var i = 0; i < len; i++) {
						var point = points[i];

						var latLng = L.latLng(point.latitude, point.longitude);

						L.marker(latLng).addTo(map).bindPopup(
							point.infoWindow,
							{
								maxWidth: 500
							}
						);

						bounds.extend(latLng);
					}
				}

				return bounds;
			};

			var drawMap = function(lat, lng) {
				var map = L.map('<@liferay_portlet.namespace />mapCanvas').setView([lat, lng], 8);

				var bounds = putMarkers(map);

				if (bounds) {
					map.fitBounds(bounds);
				}
			};

			drawMap(0, 0);
		})();
	</@>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>

<#macro getAbstract asset>
	<div class="asset-entry-abstract" id="<@liferay_portlet.namespace />assetEntryAbstract">
		<#assign showEditURL = paramUtil.getBoolean(renderRequest, "showEditURL", true) />

		<#assign assetRenderer = asset.getAssetRenderer() />

		<#if showEditURL && assetRenderer.hasEditPermission(permissionChecker)>
			<#assign redirectURL = renderResponse.createLiferayPortletURL(themeDisplay.getPlid(), themeDisplay.getPortletDisplay().getId(), "RENDER_PHASE", false) />

			${redirectURL.setParameter("struts_action", "/asset_publisher/add_asset_redirect")}

			<#assign editPortletURL = assetRenderer.getURLEdit(renderRequest, renderResponse, windowStateFactory.getWindowState("POP_UP"), redirectURL) />

			<#assign taglibEditURL = "javascript:Liferay.Util.openWindow({id: '" + renderResponse.getNamespace() + "editAsset', title: '" + htmlUtil.escapeJS(languageUtil.format(locale, "edit-x", htmlUtil.escape(assetRenderer.getTitle(locale)), false)) + "', uri:'" + htmlUtil.escapeJS(editPortletURL.toString()) + "'});" />

			<@liferay_ui["icon"]
				image = "edit"
				label = true
				message = "edit"
				url = taglibEditURL
			/>
		</#if>

		<div class="asset-entry-abstract-image">
			<img src="${assetRenderer.getThumbnailPath(renderRequest)}" />
		</div>

		<#assign assetURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, asset) />

		<div class="asset-entry-abstract-content">
			<h3><a href="${assetURL}">${assetRenderer.getTitle(locale)}</a></h3>

			<div>
				${assetRenderer.getSummary(locale)}
			</div>
		</div>

		<div class="asset-entry-abstract-footer">
			<a href="${assetURL}"><@liferay.language key="read-more" /> &raquo;</a>
		</div>
	</div>
</#macro>

<#macro silently foo>
	<#assign foo = foo />
</#macro>