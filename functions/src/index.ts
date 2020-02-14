import * as admin from "firebase-admin";
import * as Members from "./members/family-members-preview";

admin.initializeApp();

export const updateFamilyMembersPreview = Members.updateFamilyMembersPreview;
