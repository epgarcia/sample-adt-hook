<#--
Application display templates can be used to modify the look of a
specific application.

Please use the left panel to quickly add commonly used variables.
Autocomplete is also available and can be invoked by typing "${".
-->

<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#if entries?has_content>
	<@aui["script"] use="charts">
		var tagsChartDataValues = [
			<#list entries as curEntry>
				{tag:'${htmlUtil.escapeJS(curEntry.getName())}', count:${curEntry.getAssetCount()}}<#if curEntry_has_next>,</#if>
			</#list>
		];

		var tagsChart = new A.Chart({
			categoryKey:'tag',
			dataProvider: tagsChartDataValues,
			render: '#<@liferay_portlet.namespace />tagsChart',
			seriesCollection:[
				{
					categoryKey:"tag",
					valueKey:"count"
				}
			],
			seriesKeys:['count'],
			type: 'pie'
		});
	</@>

	<div id="<@liferay_portlet.namespace />tagsChart"></div>

	<style>
		#<@liferay_portlet.namespace />tagsChart {
			margin: 5% 20%;
			height: 400px;
			min-width: 600px;
			width: 100%;
		}
	</style>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>