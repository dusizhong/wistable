/*
 * APITable <https://github.com/apitable/apitable>
 * Copyright (C) 2022 APITable Ltd. <https://apitable.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.apitable.user.enums;

import com.apitable.core.exception.BaseException;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * <p>
 * user exception.
 * status code range（300-399）
 * </p>
 *
 * @author Shawn Deng
 */
@Getter
@AllArgsConstructor
public enum UserException implements BaseException {

    USER_NOT_EXIST(300, "Account does not exist or is disabled"),

    REGISTER_FAIL(301, "registration failed"),

    REGISTER_EMAIL_ERROR(301, "The registered email format is incorrect"),

    REGISTER_EMAIL_HAS_EXIST(301, "This email has been registered, please switch to sign in"),

    MOBILE_BOUND_EMAIL_DUPLICATE(332,
        "The mobile phone account is bound to a duplicate email address"),

    USERNAME_OR_PASSWORD_ERROR(302, "account or password incorrect"),

    MOBILE_EMPTY(303, "Phone number can not be blank"),

    MOBILE_ERROR_FORMAT(303, "Phone number entered incorrectly"),

    MOBILE_NO_EXIST(303, "The phone number is not registered"),

    MOBILE_HAS_REGISTER(303, "The phone number is already registered"),

    AUTH_INFO_NO_VALID(303, "The page has timeout"),

    EMAIL_NO_EXIST(304, "This email is not bound to an account"),

    EMAIL_HAS_BIND(304, "The mail has been bound"),

    PASSWORD_EMPTY(305, "password can not be blank"),

    PASSWORD_ERROR_LENGTH(305, "wrong password length"),

    PASSWORD_ERROR_TYPE(305,
        "The password format only supports English alphabet characters and numbers"),

    PASSWORD_ERROR_FORMAT(305, "Password format must contain both letters and numbers"),

    MODIFY_PASSWORD_ERROR(305, "Failed to change password"),

    PASSWORD_HAS_SETTING(305,
        "The account has already set a password, and the initialization failed"),

    LOGIN_OFTEN(306, "Frequent operations"),

    SIGN_IN_ERROR(306, "Login failed"),

    LINK_EMAIL_ERROR(306, "Failed to bind email"),

    USER_NOT_BIND_EMAIL(307, "User not bound to email"),

    USER_NOT_BIND_PHONE(307, "User is not bound to a mobile phone number"),

    USER_CHECK_FAILED(333, "User check failed"),

    DING_USER_UNKNOWN(334, "DingTalk failed to obtain user information, please log in again"),

    UPDATE_USER_INFO_FAIL(335, "Failed to update user information"),

    REGISTER_BY_INVITE_CODE_OPERATION_FREQUENTLY(336,
        "The invitation code registration operation is frequent, please try again in 10 seconds"),

    AUTH_FAIL(337, "Authorization failed"),

    MUST_BIND_EAMIL(339,
        "The user account must have a unique credential, and an email address must be bound to be able to unbind the mobile phone number"),

    MUST_BIND_MOBILE(340,
        "The user account must have a unique certificate, and a mobile phone number needs to be bound to be able to unbind the mailbox"),

    USER_LANGUAGE_SET_UN_SUPPORTED(341, "Unsupported language type");

    private final Integer code;

    private final String message;
}
