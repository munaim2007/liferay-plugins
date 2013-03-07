<%@ page import="com.liferay.portal.model.User" %>
<%@ page import="com.liferay.portal.service.UserLocalServiceUtil" %>

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
long filterBySubscriptionId = ParamUtil.getLong(request, "filterBySubscriptionId");
long filterBySubscriberId = ParamUtil.getLong(request, "filterBySubscriberId");

String filterBySubscriptionIdTitle = StringPool.BLANK;
String filterBySubscriberIdTitle = StringPool.BLANK;

if (filterBySubscriptionId > 0) {
	Subscription filterBySubscription = SubscriptionLocalServiceUtil.fetchSubscription(filterBySubscriptionId);

	AssetRenderer assetRenderer = SubscriptionManagerUtil.getAssetRenderer(filterBySubscription.getClassName(), filterBySubscription.getClassPK());

	filterBySubscriptionIdTitle = SubscriptionManagerUtil.getTitleText(locale, filterBySubscription.getClassName(), filterBySubscription.getClassPK(), ((assetRenderer != null) ? assetRenderer.getTitle(locale) : null));
}

if (filterBySubscriberId > 0) {
	User filterByUser = UserLocalServiceUtil.fetchUser(filterBySubscriberId);

	filterBySubscriberIdTitle = filterByUser.getFullName();
}
%>

<liferay-util:buffer var="removeFilterBySubscriptionId">
	<c:if test="<%= filterBySubscriptionId > 0 %>">
		<span class="asset-entry">
			<%= filterBySubscriptionIdTitle %>

			<portlet:renderURL var="viewURLWithoutFilterBySubscriptionId">
				<portlet:param name="filterBySubscriptionId" value="0" />
			</portlet:renderURL>

			<a href="<%= viewURLWithoutFilterBySubscriptionId %>" title="<liferay-ui:message key="remove" />">
				<span class="aui-icon aui-icon-close aui-textboxlistentry-close"></span>
			</a>
		</span>
	</c:if>
</liferay-util:buffer>

<liferay-util:buffer var="removeFilterBySubscriberId">
	<c:if test="<%= filterBySubscriberId > 0 %>">
		<span class="asset-entry">
			<%= filterBySubscriberIdTitle %>

			<liferay-portlet:renderURL var="viewURLWithoutFilterBySubscriberId">
				<liferay-portlet:param name="filterBySubscriberId" value="0" />
			</liferay-portlet:renderURL>

			<a href="<%= viewURLWithoutFilterBySubscriberId %>" title="<liferay-ui:message key="remove" />">
				<span class="aui-icon aui-icon-close aui-textboxlistentry-close"></span>
			</a>
		</span>
	</c:if>
</liferay-util:buffer>

<c:choose>
	<c:when test="<%= filterBySubscriptionId != 0 %>">
		<h1 class="taglib-categorization-filter entry-title">
			<liferay-ui:message arguments="<%= removeFilterBySubscriptionId %>" key='<%= "filter-by-x" %>' />
		</h1>
	</c:when>
	<c:when test="<%= filterBySubscriberId != 0 %>">
		<h1 class="taglib-categorization-filter entry-title">
			<liferay-ui:message arguments="<%= removeFilterBySubscriberId %>" key='<%= "filter-by-x" %>' />
		</h1>
	</c:when>
</c:choose>

<aui:form method="post" name="fm">
	<liferay-ui:search-container
		emptyResultsMessage="there-are-no-subscriptions"
		iteratorURL="<%= portletURL %>"
		rowChecker="<%= new RowChecker(renderResponse) %>"
	>
		<%@ include file="/subscription_search.jspf" %>

		<liferay-ui:search-container-results
			results="<%= SubscriptionManagerUtil.getSubscriptions(filterBySubscriptionId, themeDisplay.getCompanyId(), filterBySubscriberId, searchContainer.getStart(), searchContainer.getEnd(), null) %>"
			total="<%= SubscriptionManagerUtil.getSubscriptionsCount(filterBySubscriptionId, themeDisplay.getCompanyId(), filterBySubscriberId) %>"
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
	function <portlet:namespace />selectSubscription(filterBySubscriptionId) {
		location.href = Liferay.Util.addParams('<portlet:namespace />filterBySubscriptionId=' + filterBySubscriptionId, '<portlet:renderURL><portlet:param name="mvcPath" value="/view.jsp" /></portlet:renderURL>');;
	}

	function <portlet:namespace />selectSubscriber(filterBySubscriberId) {
		location.href = Liferay.Util.addParams('<portlet:namespace />filterBySubscriberId=' + filterBySubscriberId, '<portlet:renderURL><portlet:param name="mvcPath" value="/view.jsp" /></portlet:renderURL>');;
	}
</aui:script>