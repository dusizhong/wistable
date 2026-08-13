/**
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

// ================ Audit ======================

/**
 * Query space audit logs with pagination
 */
export const SPACE_AUDIT = '/space/:spaceId/audit';

// =============== Space related =======================
// get the space list
export const SPACE_LIST = '/space/list';
// create space
export const CREATE_SPACE = '/space/create';
// delete space
export const DELETE_SPACE = '/space/delete/:spaceId';
// switch space station
export const SWITCH_SPACE = '/space/:spaceId/switch';
// immediately delete the space
export const DELETE_SPACE_NOW = '/space/del';
// edit space
export const UPDATE_SPACE = '/space/update';
// exit space
export const QUIT_SPACE = '/space/quit/';
// space station-main administrator-get main administrator information
export const MAIN_ADMIN_INFO = '/space/manager';
// space station-main administrator-change main administrator
export const CHANGE_MAIN_ADMIN = '/space/changeManager';
// Space Station-Sub-Administrator-Query the list of administrators
export const LIST_ROLE = '/space/listRole';
// space station-sub-admin-get administrator information
export const SUB_ADMIN_PERMISSION = '/space/getRoleDetail';
// space station-sub-admin-add admin
export const ADD_SUB_ADMIN = '/space/addRole';
// space station-sub-admin-edit sub-admin
export const EDIT_SUB_ADMIN = '/space/editRole';
// space station-sub-admin-delete-admin
export const DELETE_SUB_ADMIN = '/space/deleteRole/';
// Space Station - Get the status of prohibiting all members from exporting the Wig table
export const FORBID_STATUS = '/space/getForbidStatus';
// space station - get the properties of space
export const GET_SPACE_FEATURES = '/space/features';
// space station - get the properties of space
export const SWITCH_NODEROLE_ASSIGNALE = '/space/updateNodeRoleAssignable';

// space station - update enterprise security settings
export const UPDATE_SECURITY_SETTING = '/space/updateSecuritySetting';

// get the space content
export const SPACE_CONTENT = '/space/content/';
// Spatial information
export const SPACE_INFO = '/space/info/';
// restore space
export const RECOVER_SPACE = '/space/cancel/';
// space capacity
export const SPACE_MEMORY = '/space/capacity';
// Toggle the working directory to be visible to all members
export const UPDATE_ALL_VISIBLE = '/space/updateNodeVisibleStatus';
// Query the visibility status of all members of the working directory
export const GET_ALL_VISIBLE = '/space/getNodeVisible';
// spatial statistics
export const SPACE_STATISTICS = '/space/statistics';
// subscribe
export const SUBSCRIBE_INFO = '/space/subscribe/';

// permission related
export const SPACE_RESOURCE = '/space/resource';
export const NO_PERMISSION_MEMBER = '/node/remind/units/noPermission';
// Give attachment space capacity details
export const CAPACITY_REWARD_LIST = '/space/capacity/detail';
// Give node capacity details
export const CAPACITY_NODE_LIST = '/space/:spaceId/node/statistics';
// email invitation
export const SEND_EMAIL_INVITATION = '/spaces/:spaceId/email-invitations';
export const RESEND_EMAIL_INVITATION = '/spaces/:spaceId/email-invitation/resend';
export const VALID_EMAIL_INVITATION = '/email-invitations/:inviteToken/valid';
export const ACCEPT_EMAIL_INVITATION = '/spaces/:spaceId/email-invitations/:inviteToken/accept';
// link invite
export const CREATE_LINK = '/space/link/generate';
export const LINK_LIST = '/space/link/list';
export const DELETE_LINK = '/space/link/delete';
export const LINK_VALID = '/space/link/valid';
export const JOIN_VIA_LINK = '/space/link/join';
// apply to join the space
export const APPLY_JOIN_SPACE = '/space/apply/join';
// =============== Space related =======================

// =============== Admin related =======================
// admin: list users
export const ADMIN_USER_LIST = '/admin/users';
// admin: create user
export const ADMIN_USER_CREATE = '/admin/users/create';
// admin: update user
export const ADMIN_USER_UPDATE = '/admin/users/:userId';
// admin: set user password
export const ADMIN_USER_PASSWORD = '/admin/users/:userId/password';
// admin: toggle user pause status
export const ADMIN_USER_TOGGLE = '/admin/users/:userId/toggle';
// admin: delete user
export const ADMIN_USER_DELETE = '/admin/users/:userId';
// admin: list all spaces
export const ADMIN_SPACE_LIST = '/admin/spaces';
// admin: create space
export const ADMIN_SPACE_CREATE = '/admin/spaces';
// admin: update space
export const ADMIN_SPACE_UPDATE = '/admin/spaces/:spaceId';
// admin: delete space
export const ADMIN_SPACE_DELETE = '/admin/spaces/:spaceId';
// admin: get space capacity config
export const ADMIN_SPACE_CAPACITY = '/admin/spaces/:spaceId/capacity';
// admin: list notifications
export const ADMIN_NOTIFICATION_LIST = '/admin/notifications';
// admin: create notification
export const ADMIN_NOTIFICATION_CREATE = '/admin/notifications';
// admin: notification detail / update / delete
export const ADMIN_NOTIFICATION_DETAIL = '/admin/notifications/:id';
// admin: send notification
export const ADMIN_NOTIFICATION_SEND = '/admin/notifications/:id/send';
// user: submit feedback
export const FEEDBACK_SUBMIT = '/feedback';
// admin: list feedbacks
export const ADMIN_FEEDBACK_LIST = '/admin/feedbacks';
// admin: process feedback
export const ADMIN_FEEDBACK_PROCESS = '/admin/feedbacks/:id/process';
// =============== Admin related =======================