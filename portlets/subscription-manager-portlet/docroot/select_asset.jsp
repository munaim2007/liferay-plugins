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
	<liferay-ui:search-container
		rowChecker="<%= userGroupGroupChecker %>"
		searchContainer="<%= userGroupSearch %>"
	>
		<liferay-ui:search-toggle
			buttonLabel="search"
			displayTerms="<%= displayTerms %>"
			id="toggle_id_users_admin_user_search"
		>
			<aui:input name="<%= displayTerms.TITLE %>" size="20" value="<%= displayTerms.getTitle() %>" />

			<aui:input name="<%= displayTerms.DESCRIPTION %>" size="20" value="<%= displayTerms.getDescription() %>" />

			<aui:input name="<%= displayTerms.USER_NAME %>" size="20" value="<%= displayTerms.getUserName() %>" />
		</liferay-ui:search-toggle>

		<liferay-ui:search-container-results>
			<%
			if (searchTerms.isAdvancedSearch()) {
				results = SubscriptionManagerUtil.getAssetEntries(themeDisplay.getCompanyId(), 0, searchTerms.getTitle(), searchContainer.getStart(), searchContainer.getEnd(), null);
				total = SubscriptionManagerUtil.getAssetEntriesCount(themeDisplay.getCompanyId(), 0, searchTerms.getTitle());
			}
			else {
				results = SubscriptionManagerUtil.getAssetEntries(themeDisplay.getCompanyId(), 0, searchTerms.getTitle(), searchContainer.getStart(), searchContainer.getEnd(), null);
				total = SubscriptionManagerUtil.getAssetEntriesCount(themeDisplay.getCompanyId(), 0, searchTerms.getTitle());
			}
			%>
		</liferay-ui:search-container-results>

		<liferay-ui:search-container-row
			className="com.liferay.portlet.asset.model.AssetEntry"
			escapedModel="<%= true %>"
			keyProperty="assetEntryId"
			modelVar="assetEntry"
		>
			<liferay-ui:search-container-column-text
				name="title"
				orderable="<%= true %>"
				property="title"
			/>
		</liferay-ui:search-container-row>
	</liferay-ui:search-container>
</form>