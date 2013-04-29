/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
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

package com.liferay.mbsubscriptionmanager.admin.portlet;

import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.service.SubscriptionLocalServiceUtil;
import com.liferay.portlet.messageboards.model.MBCategory;
import com.liferay.portlet.messageboards.service.MBCategoryLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

/**
 * @author Shinn Lok
 */
public class SubscriptionManagerPortlet extends MVCPortlet {

	public void subscribeUsers(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long mbCategoryId = ParamUtil.getLong(actionRequest, "mbCategoryId");

		MBCategory category = MBCategoryLocalServiceUtil.fetchMBCategory(
			mbCategoryId);

		long[] userIds = ParamUtil.getLongValues(actionRequest, "userIds");

		for (long userId : userIds) {
			SubscriptionLocalServiceUtil.addSubscription(
				userId, category.getGroupId(), MBCategory.class.getName(),
				category.getCategoryId());
		}

//		String namespace = actionResponse.getNamespace();
//
//		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(
//			WebKeys.THEME_DISPLAY);
//
//		String redirect = getRedirect(actionRequest, actionResponse);
//
//		String editURL = PortalUtil.getLayoutFullURL(themeDisplay);
//
//		editURL = HttpUtil.setParameter(
//				editURL, namespace + "redirect", redirect);
//
//		actionRequest.setAttribute(WebKeys.REDIRECT, editURL);

	}

	public void unsubscribeUsers(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long mbCategoryId = ParamUtil.getLong(actionRequest, "mbCategoryId");

		MBCategory category = MBCategoryLocalServiceUtil.fetchMBCategory(
			mbCategoryId);

		long[] userIds = ParamUtil.getLongValues(actionRequest, "userIds");

		for (long userId : userIds) {
			if (!SubscriptionLocalServiceUtil.isSubscribed(
					category.getCompanyId(), userId, MBCategory.class.getName(),
					mbCategoryId)) {

				continue;
			}

			SubscriptionLocalServiceUtil.deleteSubscription(
				userId, MBCategory.class.getName(), mbCategoryId);
		}
	}

}