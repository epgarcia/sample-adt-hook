<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />

<#list entries as curEntry>
	<div class="entry" style="position:relative">
		<#assign viewURL = renderResponse.createRenderURL() />

		${viewURL.setParameter("struts_action", "/blogs/view_entry")}
		${viewURL.setParameter("redirect", currentURL)}
		${viewURL.setParameter("urlTitle", curEntry.getUrlTitle())}

		<#if curEntry.isSmallImage()>
			<div class="asset-small-image">
				<img alt="" style="width:100%;height:180px;" src="${htmlUtil.escape(curEntry.getEntryImageURL(themeDisplay))}" />
			</div>
		</#if>

		<div class="img-circle img-avatar">
			<@liferay_ui["user-display"] url="" userId=curEntry.getUserId() />
		</div>

		<div class="content-padding">
			<div class="entry-content">
				<div class="entry-title">
					<h2><a href="${viewURL}">${htmlUtil.escape(curEntry.getTitle())}</a></h2>
				</div>
			</div>

			<div class="entry-body">
				<#assign summary = curEntry.getDescription() />

				<#if (validator.isNull(summary))>
					<#assign summary = curEntry.getContent() />
				</#if>

				${stringUtil.shorten(htmlUtil.stripHtml(summary), 400)}

				<a href="${viewURL}"><@liferay.language key="read-more" /> <span class="hide-accessible"><@liferay.language key="about"/>${htmlUtil.escape(curEntry.getTitle())}</span> &raquo;</a>
			</div>
		</div>
	</div>

	<div class="separator"><!-- --></div>
</#list>