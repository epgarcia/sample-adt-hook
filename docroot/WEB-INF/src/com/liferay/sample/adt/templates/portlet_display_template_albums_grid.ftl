<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#if entries?has_content && serviceLocator??>
	<#assign artistLocalService = serviceLocator.findService("jukebox-portlet", "org.liferay.jukebox.service.ArtistLocalService")>

	<div class="container-fluid albums">
		<#list entries as curEntry>
			<div class="span4 album" style="position:relative;background:#000">
				<#assign artist = artistLocalService.getArtist(entry.getArtistId()) />

				<@liferay_portlet["renderURL"] var="viewAlbumURL">
					<@liferay_portlet["param"] name="jspPage" value="/html/albums/view_album.jsp" />
					<@liferay_portlet["param"] name="albumId" value=curEntry.getAlbumId()?string />
					<@liferay_portlet["param"] name="redirect" value=currentURL/>
				</@>

				<a href="${viewAlbumURL}">
					<img src="${curEntry.getImageURL(themeDisplay)}" style="width:100%;height:340px;opacity:0.8" />
				</a>

				<div class="titles" style="position:absolute; top:5px; left:125px;text-shadow: -1px -1px 2px #000;margin-right: 20px;">
				    <h3 style="color:#FFF"><@liferay.language key="artist" />: ${htmlUtil.escape(artist.getName())} </h3>
				    <h4 style="color:#FFF"><@liferay.language key="album" />: ${htmlUtil.escape(curEntry.getName())} </h4>
				</div>

				<img src="${artist.getImageURL(themeDisplay)}" class="img-circle" style="width:80px;height:80px;position:absolute;top: 20px; left:20px; border:3px solid #ccc"/>
			</div>
		</#list>
	</div>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>