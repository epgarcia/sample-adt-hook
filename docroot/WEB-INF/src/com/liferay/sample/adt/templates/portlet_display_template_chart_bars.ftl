<#--
Application display templates can be used to modify the look of a
specific application.

Please use the left panel to quickly add commonly used variables.
Autocomplete is also available and can be invoked by typing "${".
-->

<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#if entries?has_content && serviceLocator??>
	<#assign ratingsStatsLocalService = serviceLocator.findService("com.liferay.portlet.ratings.service.RatingsStatsLocalService")>

	<@aui["script"] use="charts">
		var ratingsChartDataValues = [
			<#list entries as curEntry>
				<#assign ratingsStats = ratingsStatsLocalService.getStats(curEntry.getClassName(), curEntry.getClassPK()) />

				{asset:'${htmlUtil.escapeJS(stringUtil.shorten(curEntry.getTitle(locale)))}', rating:${ratingsStats.getTotalScore()}}<#if curEntry_has_next>,</#if>
			</#list>
		];

		var ratingsChartAxes = {
			rating:{
				keys:['rating'],
				position:'bottom',
				title:'<@liferay.language key="rating" />',
				type:'numeric'
			},
			asset:{
				keys:['asset'],
				position:'left',
				title:'<@liferay.language key="asset" />',
				type:'category'
			}
		};

		var ratingsChartStyles = {
			axes:{
				asset:{
					label:{
						margin:{top:5},
						rotation:-45
					}
				}
			},
			series:{
				rating:{
					marker:{
						fill:{
							color:'#45cbf5'
						},
						over:{
							fill:{
								color:'#5bbae8'
							}
						}
					}
				}
			}
		};

		var ratingsChart = new A.Chart({
			axes: ratingsChartAxes,
			dataProvider: ratingsChartDataValues,
			horizontalGridlines: true,
			render: '#<@liferay_portlet.namespace />ratingsChart',
			styles: ratingsChartStyles,
			type: 'bar',
			verticalGridlines: true
		});
	</@>

	<div id="<@liferay_portlet.namespace />ratingsChart"></div>

	<style>
		#<@liferay_portlet.namespace />ratingsChart {
			height: 400px;
			min-width: 300px;
			width: 100%;
		}
	</style>
<#else>
	<div class="alert alert-info">
		<@liferay.language key="not-availanle" />
	</div>
</#if>