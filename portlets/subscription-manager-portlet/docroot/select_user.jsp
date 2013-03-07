<%@ page import="com.liferay.portal.kernel.dao.search.SearchContainer" %>
<%@ page import="com.liferay.portal.kernel.util.*" %>

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
portletURL = renderResponse.createRenderURL();

portletURL.setParameter("mvcPath", "/select_user.jsp");
%>

<form action="<%= portletURL.toString() %>" method="post" name="<portlet:namespace />fm" onSubmit="submitForm(this); return false;">

	<%
	LinkedHashMap userParams = new LinkedHashMap();
	%>

	<liferay-ui:user-search
		portletURL="<%= portletURL %>"
		userParams="<%= userParams %>"
	>

		<%
		SearchContainer userSearchContainer = (SearchContainer)request.getAttribute(WebKeys.SEARCH_CONTAINER);
		%>

		<liferay-ui:search-container
			headerNames="name,screen-name,email-address"
			searchContainer="<%= userSearchContainer %>"
		>
			<liferay-ui:search-container-results
				results="<%= userSearchContainer.getResults() %>"
				total="<%= userSearchContainer.getTotal() %>"
			/>

			<liferay-ui:search-container-row
				className="com.liferay.portal.model.User"
				keyProperty="userId"
				modelVar="curUser"
			>

				<%
				StringBundler sb = new StringBundler(8);

		 		sb.append("javascript:opener.");
		 		sb.append(renderResponse.getNamespace());
				sb.append("selectSubscriber('");
		 		sb.append(curUser.getUserId());
				sb.append("'); window.close();");

				String rowHREF = sb.toString();
				%>

				<liferay-ui:search-container-column-text
					href="<%= rowHREF %>"
					name="name"
					value="<%= HtmlUtil.escape(curUser.getFullName()) %>"
				/>

				<liferay-ui:search-container-column-text
					href="<%= rowHREF %>"
					name="screen-name"
					value="<%= HtmlUtil.escape(curUser.getScreenName()) %>"
				/>

				<liferay-ui:search-container-column-text
					href="<%= rowHREF %>"
					name="email-address"
					property="emailAddress"
				/>
			</liferay-ui:search-container-row>

			<liferay-ui:search-iterator />
		</liferay-ui:search-container>
	</liferay-ui:user-search>
</form>