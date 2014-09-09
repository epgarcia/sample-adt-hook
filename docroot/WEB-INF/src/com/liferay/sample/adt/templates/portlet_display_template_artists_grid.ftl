<#assign aui = taglibLiferayHash["/WEB-INF/tld/aui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#if entries?has_content && serviceLocator??>
	<#assign albumLocalService = serviceLocator.findService("jukebox-portlet", "org.liferay.jukebox.service.AlbumLocalService")>

	<div class="container-fluid artists">
		<#list entries as curEntry>
			<div class="span4 artist">
				<@liferay_portlet["renderURL"] var="viewArtistURL">
					<@liferay_portlet["param"] name="jspPage" value="/html/artists/view_artist.jsp" />
					<@liferay_portlet["param"] name="artistId" value=curEntry.getArtistId()?string />
					<@liferay_portlet["param"] name="redirect" value=currentURL />
				</@>

				<a href="${viewArtistURL}">
					<img src="${curEntry.getImageURL(themeDisplay)}" class="artist-img" />

					<h2>
						${htmlUtil.escape(curEntry.getName())}
					</h2>
				</a>

				<#assign albumList = albumLocalService.getAlbumsByArtistId(curEntry.getArtistId()) />

				<div class="container-fluid albums">
					<#list albumList as album>
						<div class="album">
							<span class="min-circle"></span>

							<@liferay_portlet["renderURL"] var="viewAlbumURL">
								<@liferay_portlet["param"] name="jspPage" value="/html/albums/view_album.jsp" />
								<@liferay_portlet["param"] name="albumId" value=album.getAlbumId()?string />
								<@liferay_portlet["param"] name="redirect" value=currentURL/>
							</@>

							<a href="${viewAlbumURL}">
								<h3>
									${htmlUtil.escape(album.getName())}
								</h3>

								<img src="${album.getImageURL(themeDisplay)}" class="album-img" />
							</a>
						</div>
					</#list>
				</div>
			</div>
		</#list>
	</div>
<#else>
	${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
</#if>