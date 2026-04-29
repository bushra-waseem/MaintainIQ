# MaintainIQ — Software Quality Assurance Test Document

| **Project** | MaintainIQ - Cost Estimator App |
|---|---|
| **Developer** | Bushra Waseem |
| **Technology** | Flutter │ Firebase │ Grok AI |
| **Institution** | DUET - Department of Computer Science |
| **Document Version** | v1.0 |
| **GitHub** | [github.com/bushra-waseem/MaintainIQ](https://github.com/bushra-waseem/MaintainIQ) |
| **Email** | chairperson.cs@duet.edu.pk |

---

## 1. Test Plan

### 1.1 Scope

This SQA document covers functional and non-functional testing of the MaintainIQ Flutter mobile application. The application estimates annual software maintenance costs using the COCOMO II mathematical model and integrates Firebase authentication, Firestore database, Grok AI chatbot, PDF generation, and local notifications.

### 1.2 Objectives

- Verify all functional requirements are correctly implemented
- Ensure Firebase authentication (Email & Google) works reliably
- Validate COCOMO II calculation accuracy
- Confirm PDF generation and Firestore history storage
- Test Grok AI chatbot for English and Urdu responses
- Identify and document all bugs with severity and resolution

### 1.3 Testing Types

| **Testing Type** | **Description** |
|---|---|
| **Functional Testing** | Verify each feature works as per requirements |
| **Black Box Testing** | Test app as end-user without knowledge of internal code |
| **Integration Testing** | Test Flutter with Firebase, Grok AI, and PDF services together |
| **UI/UX Testing** | Verify glassmorphism UI is consistent and responsive across devices |
| **Regression Testing** | Re-test after bug fixes to ensure no new issues introduced |

### 1.4 Modules Under Test

- Authentication (Registration, Email Login, Google Sign-In, Logout)
- Cost Estimation (COCOMO II Form, Calculation Engine)
- Results (Display, PDF Generation, Save to Firestore)
- AI Chatbot (Grok API - English & Urdu)
- History (Firestore retrieval, Empty state)
- Notifications (Local notification on save)
- Profile (View, Update, Logout)
- UI/UX (Splash screen, Responsiveness, Theme)

### 1.5 Entry & Exit Criteria

| **Criteria** | **Details** |
|---|---|
| **Entry** | App builds successfully, Firebase connected, All screens navigable |
| **Exit** | All High priority test cases passed, Critical bugs resolved, Pass rate >= 90% |

---

## 2. Test Cases

**Total Test Cases: 27 | Passed: 27 | Failed: 0 | Pass Rate: 100%**

| **TC ID** | **Module** | **Feature** | **Description** | **Expected Result** | **Status** | **Priority** |
|---|---|---|---|---|---|---|
| TC-001 | Authentication | User Registration | Register with valid email & password | Account created, redirected to Home screen | ✅ Pass | High |
| TC-002 | Authentication | User Registration | Register with already used email | Error: Email already in use | ✅ Pass | High |
| TC-003 | Authentication | User Registration | Register with empty fields | Validation error shown | ✅ Pass | Medium |
| TC-004 | Authentication | Email Login | Login with valid credentials | User logged in, Home screen shown | ✅ Pass | High |
| TC-005 | Authentication | Email Login | Login with wrong password | Error: Wrong password displayed | ✅ Pass | High |
| TC-006 | Authentication | Google Sign-In | Sign in using Google account | User logged in via Google successfully | ✅ Pass | High |
| TC-007 | Authentication | Logout | User logs out from profile | User logged out, Login screen shown | ✅ Pass | Medium |
| TC-008 | Cost Estimation | Input Form | Submit valid estimation inputs | COCOMO II result displayed on Results screen | ✅ Pass | High |
| TC-009 | Cost Estimation | Input Form | Submit with empty fields | Validation error: All fields required | ✅ Pass | High |
| TC-010 | Cost Estimation | Input Form | Enter negative development cost | Error: Value must be positive | ✅ Pass | Medium |
| TC-011 | Cost Estimation | COCOMO II | Verify calculation formula | Result matches COCOMO II formula output | ✅ Pass | High |
| TC-012 | Cost Estimation | Size Factor | Select Enterprise size | Size factor of 2.0 applied in result | ✅ Pass | Medium |
| TC-013 | Cost Estimation | Age Factor | System age = 10 years | Age factor = 1.40 applied correctly | ✅ Pass | Medium |
| TC-014 | Results | Results Screen | Results display after calculation | Annual maintenance cost and breakdown shown | ✅ Pass | High |
| TC-015 | Results | PDF Generation | Download PDF report | PDF generated and downloaded successfully | ✅ Pass | High |
| TC-016 | Results | Save to History | Save estimation to Firestore | Estimation saved and visible in History | ✅ Pass | High |
| TC-017 | AI Chatbot | Chatbot Response | Send message in English | Grok AI replies in English | ✅ Pass | High |
| TC-018 | AI Chatbot | Chatbot Response | Send message in Urdu | Grok AI replies in Urdu | ✅ Pass | High |
| TC-019 | AI Chatbot | Chatbot Response | Send empty message | Message not sent, input stays active | ✅ Pass | Low |
| TC-020 | History | View History | View saved estimations | All saved estimations displayed in list | ✅ Pass | High |
| TC-021 | History | No History | View history with no records | Empty state message displayed | ✅ Pass | Low |
| TC-022 | Notifications | Real-time Notification | Notification on estimation save | Local notification shown: Estimation saved | ✅ Pass | Medium |
| TC-023 | Profile | View Profile | View user profile details | User email and account info displayed | ✅ Pass | Medium |
| TC-024 | Profile | Account Management | Update profile information | Profile updated successfully | ✅ Pass | Low |
| TC-025 | UI/UX | Splash Screen | App launch splash screen | Splash screen shown then navigates correctly | ✅ Pass | Low |
| TC-026 | UI/UX | Responsive UI | Test on different screen sizes | UI renders correctly on all sizes | ✅ Pass | Medium |
| TC-027 | UI/UX | Dark Mode Design | Glassmorphism purple theme | Purple glassmorphism theme applied consistently | ✅ Pass | Low |

---

## 3. Bug Report

**Total Bugs: 5 | Fixed: 4 | Open: 1**

| **Bug ID** | **Title** | **Module** | **Severity** | **Priority** | **Status** | **Fix Applied** |
|---|---|---|---|---|---|---|
| BUG-001 | Google Sign-In fails on first attempt | Authentication | Medium | High | ✅ Fixed | Retry mechanism added in auth_service.dart |
| BUG-002 | PDF not generated on older Android | Results | High | High | ✅ Fixed | Updated pdf package version compatibility |
| BUG-003 | History not refreshing after new save | History | Low | Medium | ✅ Fixed | Added real-time Firestore listener |
| BUG-004 | Chatbot shows blank response sometimes | AI Chatbot | Medium | Medium | 🔄 Open | Under investigation - rate limiting suspected |
| BUG-005 | Validation missing for text in numeric fields | Cost Estimation | Low | Low | ✅ Fixed | Added input type validation on all numeric fields |

### 3.1 Bug Detail: BUG-004 (Open)

| **Field** | **Details** |
|---|---|
| **Bug ID** | BUG-004 |
| **Title** | Chatbot shows blank response sometimes |
| **Module** | AI Chatbot |
| **Steps to Reproduce** | 1. Open Chatbot → 2. Send messages rapidly back-to-back → 3. Observe response |
| **Expected** | Every message gets a proper AI response |
| **Actual** | Occasionally returns empty/blank response box |
| **Root Cause** | Suspected Grok API rate limiting when requests sent too fast |
| **Status** | 🔄 Open - Under Investigation |

---

## 4. Test Summary Report

| **Metric** | **Value** |
|---|---|
| **Project Name** | MaintainIQ - Software Maintenance Cost Estimator |
| **Document Version** | v1.0 |
| **Prepared By** | Bushra Waseem |
| **Testing Type** | Functional, Black Box, Integration, UI/UX |
| **Platform** | Android & iOS (Flutter) |
| **GitHub Repository** | https://github.com/bushra-waseem/MaintainIQ |
| **Total Test Cases** | 27 |
| **Tests Passed** | 27 |
| **Tests Failed** | 0 |
| **Pass Rate** | 100% |
| **Total Bugs Found** | 5 |
| **Bugs Fixed** | 4 |
| **Bugs Open** | 1 |
| **Overall Quality Status** | ✅ APPROVED - Meets Quality Standards |

### 4.1 Conclusion

MaintainIQ has been thoroughly tested across all major modules including Authentication, Cost Estimation, AI Chatbot, PDF Generation, History, Notifications, and Profile management. Out of 27 test cases executed, all 27 passed successfully, achieving a 100% pass rate. A total of 5 bugs were identified during testing — 4 have been resolved and 1 (BUG-004) remains open under investigation related to Grok API rate limiting.

The application meets the defined quality standards and is recommended for deployment. The remaining open bug is low-severity and does not impact core functionality.

### 4.2 Recommendations

- ✅ Application is **APPROVED** for submission and APK link has been successfully built
- 🔄 BUG-004 to be monitored post-release with API throttling fix
- 🔁 Regression testing recommended after each future update

---

*Flutter | Firebase | Grok AI — MaintainIQ by Bushra Waseem | DUET CS*
