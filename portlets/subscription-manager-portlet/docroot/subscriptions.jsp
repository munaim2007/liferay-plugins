<%@ page import="com.liferay.portal.model.User" %>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.asset.model.AssetEntry" %>
<%@ page import="com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>

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

<%
long filterByClassNameId = ParamUtil.getLong(request, "filterByClassNameId");
long filterByClassPK = ParamUtil.getLong(request, "filterByClassPK");
long filterBySubscriberId = ParamUtil.getLong(request, "filterBySubscriberId");

String filterBySubscriptionIdTitle = StringPool.BLANK;
String filterBySubscriberIdTitle = StringPool.BLANK;

if (filterByClassPK > 0) {
	String filterByClassName = PortalUtil.getClassName(filterByClassNameId);

	AssetEntry assetEntry = AssetEntryLocalServiceUtil.fetchEntry(filterByClassName, filterByClassPK);

	filterBySubscriptionIdTitle = assetEntry.getTitle(locale);
}
else if (filterBySubscriberId > 0) {
	User filterByUser = UserLocalServiceUtil.fetchUser(filterBySubscriberId);

	filterBySubscriberIdTitle = filterByUser.getFullName();
}
%>

<liferay-util:buffer var="removeFilterByAsset">
	<c:if test="<%= filterByClassPK > 0 %>">
		<span class="asset-entry">
			<%= filterBySubscriptionIdTitle %>

			<portlet:renderURL var="viewURLWithoutFilterByAsset">
				<portlet:param name="filterByClassNameId" value="0" />
				<portlet:param name="filterByClassPK" value="0" />
			</portlet:renderURL>

			<a href="<%= viewURLWithoutFilterByAsset %>" title="<liferay-ui:message key="remove" />">
				<span class="aui-icon aui-icon-close aui-textboxlistentry-close"></span>
			</a>
		</span>
	</c:if>
</liferay-util:buffer>

<liferay-util:buffer var="removeFilterBySubscriber">
	<c:if test="<%= filterBySubscriberId > 0 %>">
		<span class="asset-entry">
			<%= filterBySubscriberIdTitle %>

			<liferay-portlet:renderURL var="viewURLWithoutFilterBySubscriber">
				<liferay-portlet:param name="filterBySubscriberId" value="0" />
			</liferay-portlet:renderURL>

			<a href="<%= viewURLWithoutFilterBySubscriber %>" title="<liferay-ui:message key="remove" />">
				<span class="aui-icon aui-icon-close aui-textboxlistentry-close"></span>
			</a>
		</span>
	</c:if>
</liferay-util:buffer>

<c:choose>
	<c:when test="<%= filterByClassPK > 0 %>">
		<h1 class="taglib-categorization-filter entry-title">
			<liferay-ui:message arguments="<%= removeFilterByAsset %>" key='<%= "filter-by-x" %>' />
		</h1>
	</c:when>
	<c:when test="<%= filterBySubscriberId > 0 %>">
		<h1 class="taglib-categorization-filter entry-title">
			<liferay-ui:message arguments="<%= removeFilterBySubscriber %>" key='<%= "filter-by-x" %>' />
		</h1>
	</c:when>
</c:choose>

<input class="aui-button-input" onClick="var selectAssetWindow = window.open('<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>"><portlet:param name="mvcPath" value="/select_asset.jsp" /></portlet:renderURL>', 'select_asset', 'directories=no,height=640,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=680'); void(''); selectAssetWindow.focus();" type="button" value="<liferay-ui:message key="choose" />" />

<input class="aui-button-input" onClick="var selectUserWindow = window.open('<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>"><portlet:param name="mvcPath" value="/select_user.jsp" /></portlet:renderURL>', 'select_user', 'directories=no,height=640,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=680'); void(''); selectUserWindow.focus();" type="button" value="<liferay-ui:message key="choose" />" />

<aui:form method="post" name="fm">
	<liferay-ui:search-container
		emptyResultsMessage="there-are-no-subscriptions"
		iteratorURL="<%= portletURL %>"
		rowChecker="<%= new RowChecker(renderResponse) %>"
	>
		<liferay-ui:search-container-results
			results="<%= SubscriptionManagerUtil.getSubscriptions(themeDisplay.getCompanyId(), filterBySubscriberId, filterByClassNameId, filterByClassPK, searchContainer.getStart(), searchContainer.getEnd(), null) %>"
			total="<%= SubscriptionManagerUtil.getSubscriptionsCount(themeDisplay.getCompanyId(), filterBySubscriberId, filterByClassNameId, filterByClassPK) %>"
		/>

			<liferay-ui:search-container-row
				className="com.liferay.portal.model.Subscription"
				escapedModel="<%= true %>"
				keyProperty="subscriptionId"
				modelVar="subscription"
			>

				<%
				StringBundler sb = new StringBundler(5);

				sb.append("javascript:");
				sb.append(renderResponse.getNamespace());
				sb.append("selectSubscription('");
				sb.append(subscription.getSubscriptionId());
				sb.append("');");

				String rowHREF1 = sb.toString();

				AssetRenderer assetRenderer = SubscriptionManagerUtil.getAssetRenderer(subscription.getClassName(), subscription.getClassPK());
				%>

			<liferay-ui:search-container-column-text
				href="<%= rowHREF1 %>"
				name="title"
				value="<%= SubscriptionManagerUtil.getTitleText(locale, subscription.getClassName(), subscription.getClassPK(), ((assetRenderer != null) ? assetRenderer.getTitle(locale) : null)) %>"
			/>

			<liferay-ui:search-container-column-text
				name="asset-type"
				value="<%= ResourceActionsUtil.getModelResource(locale, subscription.getClassName()) %>"
			/>

			<%
			User subscriber = UserLocalServiceUtil.fetchUser(subscription.getUserId());

			sb = new StringBundler(5);

			sb.append("javascript:");
			sb.append(renderResponse.getNamespace());
			sb.append("selectSubscriber('");
			sb.append(subscription.getUserId());
			sb.append("');");

			String rowHREF = sb.toString();
			%>

			<liferay-ui:search-container-column-text
				href="<%= rowHREF %>"
				name="user"
				value="<%= subscriber.getFullName() %>"
			/>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator />
	</liferay-ui:search-container>
</aui:form>

<aui:script>
	function <portlet:namespace />selectAsset(filterByClassNameId, filterByClassPK) {
		location.href = Liferay.Util.addParams('<portlet:namespace />filterByClassNameId=' + filterByClassNameId + '&<portlet:namespace />filterByClassPK=' + filterByClassPK, '<portlet:renderURL><portlet:param name="mvcPath" value="/view.jsp" /></portlet:renderURL>');
	}

	function <portlet:namespace />selectSubscriber(filterBySubscriberId) {
		location.href = Liferay.Util.addParams('<portlet:namespace />filterBySubscriberId=' + filterBySubscriberId, '<portlet:renderURL><portlet:param name="mvcPath" value="/view.jsp" /></portlet:renderURL>');;
	}
</aui:script>