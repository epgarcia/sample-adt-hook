/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.sample.adt.hook.events;

import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.xml.Document;
import com.liferay.portal.kernel.xml.Element;
import com.liferay.portal.kernel.xml.SAXReaderUtil;
import com.liferay.portal.model.Group;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.blogs.model.BlogsEntry;
import com.liferay.portlet.dynamicdatamapping.model.DDMTemplate;
import com.liferay.portlet.dynamicdatamapping.model.DDMTemplateConstants;
import com.liferay.portlet.dynamicdatamapping.service.DDMTemplateLocalServiceUtil;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.model.ExpandoTableConstants;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.util.ContentUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * @author Eduardo Garcia
 */
public class StartupAction extends SimpleAction {

	public List<Element> getSampleTemplateElements() throws Exception {
		Class<?> clazz = getClass();

		String xml = StringUtil.read(
			clazz.getClassLoader(), _TEMPLATES_CONFIG_PATH, false);

		Document document = SAXReaderUtil.read(xml);

		Element rootElement = document.getRootElement();

		return rootElement.elements("template");
	}

	@Override
	public void run(String[] ids) throws ActionException {
		try {
			doRun(GetterUtil.getLong(ids[0]));
		}
		catch (Exception e) {
			throw new ActionException(e);
		}
	}

	protected void addDDMTemplate(
			long userId, long groupId, long classNameId, String templateKey,
			String name, String description, String language,
			String scriptFileName, boolean cacheable,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		DDMTemplate ddmTemplate = DDMTemplateLocalServiceUtil.fetchTemplate(
			groupId, classNameId, templateKey);

		if (ddmTemplate != null) {
			return;
		}

		Map<Locale, String> nameMap = new HashMap<Locale, String>();

		Locale locale = PortalUtil.getSiteDefaultLocale(groupId);

		nameMap.put(locale, LanguageUtil.get(locale, name));

		Map<Locale, String> descriptionMap = new HashMap<Locale, String>();

		descriptionMap.put(locale, LanguageUtil.get(locale, description));

		String script = ContentUtil.get(scriptFileName);

		DDMTemplateLocalServiceUtil.addTemplate(
			userId, groupId, classNameId, 0, templateKey, nameMap,
			descriptionMap, DDMTemplateConstants.TEMPLATE_TYPE_DISPLAY, null,
			language, script, cacheable, false, null, null, serviceContext);
	}

	protected void addDDMTemplates(long companyId) throws Exception {
		ServiceContext serviceContext = new ServiceContext();

		Group group = GroupLocalServiceUtil.getCompanyGroup(companyId);

		serviceContext.setScopeGroupId(group.getGroupId());

		long defaultUserId = UserLocalServiceUtil.getDefaultUserId(companyId);

		serviceContext.setUserId(defaultUserId);

		List<Element> templateElements = getSampleTemplateElements();

		for (Element templateElement : templateElements) {
			String className = templateElement.elementText("class-name");
			String templateKey = templateElement.elementText("template-key");

			long classNameId = PortalUtil.getClassNameId(className);

			DDMTemplate ddmTemplate = DDMTemplateLocalServiceUtil.fetchTemplate(
				group.getGroupId(), classNameId, templateKey);

			if (ddmTemplate != null) {
				continue;
			}

			String name = templateElement.elementText("name");
			String description = templateElement.elementText("description");
			String language = templateElement.elementText("language");
			String scriptFileName = templateElement.elementText("script-file");

			boolean cacheable = GetterUtil.getBoolean(
				templateElement.elementText("cacheable"));

			addDDMTemplate(
				defaultUserId, group.getGroupId(), classNameId, templateKey,
				name, description, language, scriptFileName, cacheable,
				serviceContext);
		}
	}

	protected void addExpandoColumn(long companyId) throws Exception {
		ExpandoTable expandoTable = null;

		try {
			expandoTable = ExpandoTableLocalServiceUtil.addTable(
				companyId, BlogsEntry.class.getName(),
				ExpandoTableConstants.DEFAULT_TABLE_NAME);
		}
		catch (Exception e) {
			expandoTable = ExpandoTableLocalServiceUtil.getTable(
				companyId, BlogsEntry.class.getName(),
				ExpandoTableConstants.DEFAULT_TABLE_NAME);
		}

		try {
			ExpandoColumnLocalServiceUtil.addColumn(
				expandoTable.getTableId(), "geolocation",
				ExpandoColumnConstants.STRING);
		}
		catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("Custom field already exists");
			}
		}
	}

	protected void doRun(long companyId) throws Exception {
		addDDMTemplates(companyId);

		addExpandoColumn(companyId);
	}

	private static final String _TEMPLATES_CONFIG_PATH =
		"com/liferay/sample/adt/templates/portlet-display-templates.xml";

	private static Log _log = LogFactoryUtil.getLog(StartupAction.class);

}