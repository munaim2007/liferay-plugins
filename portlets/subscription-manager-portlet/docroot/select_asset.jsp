<%@ page import="com.liferay.portal.kernel.dao.search.SearchContainer" %>
<%@ page import="com.liferay.portal.kernel.util.*" %>
<%@ page import="com.liferay.portal.service.GroupLocalServiceUtil" %>
<%@ page import="com.liferay.portal.model.Group" %>
<%@ page import="com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.asset.model.AssetRendererFactory" %>
<%@ page import="com.liferay.portal.kernel.search.Hits" %>
<%@ page import="com.liferay.portlet.asset.AssetRendererFactoryRegistryUtil" %>
<%@ page import="com.liferay.portal.kernel.workflow.WorkflowConstants" %>
<%@ page import="com.liferay.subscriptionmanager.search.AssetSearchTerms" %>
<%@ page import="com.liferay.portal.kernel.search.Field" %>
<%@ page import="com.liferay.portal.kernel.search.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liferay.portal.kernel.dao.search.ResultRow" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="com.liferay.portlet.asset.model.AssetEntry" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.liferay.portlet.journal.model.JournalArticle" %>
<%@ page import="com.liferay.subscriptionmanager.util.SubscriptionManagerUtil" %>

<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
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
--%>

<%@ include file="/init.jsp" %>

<%
AssetSearch searchContainer = new AssetSearch(renderRequest, portletURL);

AssetDisplayTerms displayTerms = (AssetDisplayTerms)searchContainer.getDisplayTerms();

AssetSearchTerms searchTerms = (AssetSearchTerms)searchContainer.getSearchTerms();

portletURL = renderResponse.createRenderURL();

portletURL.setParameter("mvcPath", "/select_asset.jsp");
%>

<form action="<%= portletURL.toString() %>" method="post" name="<portlet:namespace />fm" onSubmit="submitForm(this); return false;">
	<liferay-ui:search-toggle
		buttonLabel="search"
		displayTerms="<%= displayTerms %>"
		id="toggle_id_users_admin_user_search"
	>
		<aui:input name="<%= displayTerms.TITLE %>" size="20" value="<%= displayTerms.getTitle() %>" />

		<aui:input name="<%= displayTerms.DESCRIPTION %>" size="20" value="<%= displayTerms.getDescription() %>" />

		<aui:input name="<%= displayTerms.USER_NAME %>" size="20" value="<%= displayTerms.getUserName() %>" />
	</liferay-ui:search-toggle>

	<%
	Hits results = null;

	if (searchTerms.isAdvancedSearch()) {
		results = SubscriptionManagerUtil.getAssetEntries(themeDisplay.getCompanyId()), null, searchTerms.getTitle(), WorkflowConstants.STATUS_APPROVED, searchContainer.getStart(), searchContainer.getEnd(), null);
	}
	else {
		results = SubscriptionManagerUtil.getAssetEntries(themeDisplay.getCompanyId()), null, searchTerms.getTitle(), WorkflowConstants.STATUS_APPROVED, searchContainer.getStart(), searchContainer.getEnd(), null);
	}

	int total = results.getLength();

	searchContainer.setTotal(total);

	List resultRows = searchContainer.getResultRows();

	for (int i = 0; i < results.getDocs().length; i++) {
		Document doc = results.doc(i);

		ResultRow row = new ResultRow(doc, i, i);

		String entryClassName = GetterUtil.getString(doc.get(Field.ENTRY_CLASS_NAME));
		long assetEntryId = 0;

		if (entryClassName.equals(JournalArticle.class.getName())) {
			assetEntryId = GetterUtil.getLong(doc.get(Field.ROOT_ENTRY_CLASS_PK));
		}
		else {
			assetEntryId = GetterUtil.getLong(doc.get(Field.ENTRY_CLASS_PK));
		}

		AssetEntry assetEntry = AssetEntryLocalServiceUtil.fetchEntry("com.liferay.portlet.messageboards.model.MBThread", assetEntryId);

		System.out.println(doc);
		if (assetEntry == null) {
			return;
		}
		assetEntry = assetEntry.toEscapedModel();

		StringBundler sb = new StringBundler(8);

		sb.append("javascript:opener.");
		sb.append(renderResponse.getNamespace());
		sb.append("selectAsset('");
		sb.append(assetEntry.getClassNameId());
		sb.append("', '");
		sb.append(assetEntryId);
		sb.append("'); window.close();");

		String rowHREF = sb.toString();

		Group group = GroupLocalServiceUtil.getGroup(assetEntry.getGroupId());

		// Title

		row.addText(assetEntry.getTitle(locale), rowHREF);

		// Description

		row.addText(HtmlUtil.stripHtml(HtmlUtil.unescape(assetEntry.getDescription(locale))), rowHREF);

		// Asset type

		row.addText(ResourceActionsUtil.getModelResource(locale, entryClassName));

		// User name

		row.addText(PortalUtil.getUserName(assetEntry), rowHREF);

		// Scope

		row.addText(group.getDescriptiveName(locale), rowHREF);

		// Add result row

		resultRows.add(row);
	}
	%>

	<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />
</form>