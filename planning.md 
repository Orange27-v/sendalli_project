# **Sendalli: Implementation Plan — Part 1 (Splash, Onboarding & Auth)**

## **1. Purpose & Outcome**
This document defines the exact blueprint for **Part 1 of the Sendalli Flutter Application**. 
It covers the initial launch, cold-start session routing, guest receiver tracking, universal 45-second user registration, role selection, progressive verification, and permission handling using the UI designs in `Ride Sharing App - Rider App/01_Onboarding_and_Auth/`.

---

## **2. Architecture & Tech Specifications**

* **Frontend:** Flutter (Target: Android 2GB+ RAM devices, iOS).
* **Local Storage / Session Cache:** `flutter_secure_storage` (PIN, Sanctum tokens) & `hive_flutter` (active tracking sessions, offline draft data).
* **State Management:** Riverpod or BLoC / Cubit with strict immutability and no `any` dynamic types.
* **Backend Target:** Laravel 11 API via Sanctum (Phone + PIN / Termii OTP authentication).
* **Styling & Design System:** Minimal, modern, high-contrast UI tailored for Nigerian road conditions (sunlight visibility, large tap targets, standard system font).

---

## **3. Screen-by-Screen Flow & UI Mapping**

```
[ Cold Launch ]
       │
       ▼
[ Native Splash (0-1s) ]
       │
       ├─► Has Active Session? ──► [ Role Dashboard (Home) ]
       ├─► Has Active Tracking? ─► [ Guest Tracking Screen ]
       │
       ▼ (First time / Logged out)
[ Screen 1: Welcome & Splash (Onboarding.png) ]
       │
       ├─► "Track a Package" ──► [ Bottom Sheet: Enter Tracking ID ] ──► [ Guest Tracking ]
       ├─► "Log In" ───────────► [ Phone + 4-Digit PIN ] ─────────────► [ Role Dashboard ]
       │
       ▼ "Get Started"
[ Screen 2: Full Name (Onboarding-1.png) ]
       │
       ▼
[ Screen 3: Phone Number (+234) (Onboarding-2.png) ]
       │
       ▼
[ Screen 4: SMS OTP Verification (Onboarding-3.png) ]
       │ (Auto-read / WhatsApp fallback)
       ▼
[ Screen 5: 4-Digit Security PIN (Onboarding-6.png) ]
       │
       ▼
[ Screen 6: Role Selection (Onboarding-10.png) ]
       │
       ├─────────────────────┼─────────────────────┐
       ▼                     ▼                     ▼
[ Branch A: Sender ]   [ Branch B: Rider ]   [ Branch C: Hub ]
• Shop/Business Name   • Driver Selfie       • Shop Name & Landmark
• Push Notifications   • Plate Number        • Roadside Store Photo
                       • Corridor & Park     • Operating Hours
                       • Location Access
                       • Base Trust Score: 80
       │                     │                     │
       └─────────────────────┼─────────────────────┘
                             ▼
               [ Screen 7: Profile Completed ]
                  (Modal - Location-2.png)
                             │
                             ▼
                    [ Role Home Screen ]
```

---

### **Screen 1: Splash & Welcome Gateway (`Onboarding.png`)**
* **Trigger:** App cold start when no active session exists.
* **UI Elements:**
  * Centered Sendalli brand mark and tagline (*"Fast, Affordable Package Delivery on Keke Routes"*).
  * High-contrast vector hero graphic depicting corridor logistics.
* **User Actions:**
  * `Primary Button`: **"Get Started"** $\rightarrow$ Proceeds to Screen 2.
  * `Secondary Link`: **"I have an account • Log In"** $\rightarrow$ Routes to Phone + PIN entry.
  * `Guest Fast-Track`: **"Track a Package"** $\rightarrow$ Displays modal sheet with input `SND-WAR-XXXX` to track immediately without an account.

---

### **Screen 2: Name Identification (`Onboarding-1.png`)**
* **UI Elements:**
  * Clean progress header (`Step 1 of 4`).
  * Headline: *"What's your name?"*
  * Inputs: `First Name` and `Last Name`.
* **Validation & Constraints:**
  * Auto-capitalizes first letters.
  * Minimum 2 characters per field.
  * Submit button enables dynamically only when both inputs are valid.

---

### **Screen 3: Phone Number (`Onboarding-2.png`)**
* **UI Elements:**
  * Progress header (`Step 2 of 4`).
  * Headline: *"Enter your mobile number"*.
  * Prefix container locked to `🇳🇬 +234`.
  * Phone text field.
* **Validation & Formatting:**
  * Strips leading zero automatically (typing `0803...` turns into `803...`).
  * Validates standard Nigerian length (10 digits after prefix).
  * Rate-limit guard to prevent multiple OTP triggers.

---

### **Screen 4: Termii SMS OTP Verification (`Onboarding-3.png`)**
* **UI Elements:**
  * Progress header (`Step 3 of 4`).
  * Headline: *"We sent you a verification code"*.
  * Sub-text displaying masked number: *"Sent to +234 803 *** 1234"*.
  * 4-digit / 6-digit individual box inputs.
* **UX & Recovery:**
  * Automatic clipboard paste detection & SMS autofill listener.
  * 60-second resend countdown timer.
  * Secondary button: *"Resend via WhatsApp"* (active after 60s expires).

---

### **Screen 5: 4-Digit Security PIN (`Onboarding-6.png`)**
* **UI Elements:**
  * Progress header (`Step 4 of 4`).
  * Headline: *"Create your 4-digit login PIN"*.
  * Subtitle: *"Use this PIN to quickly sign in anytime."*
  * 4 obscured PIN indicator dots.
  * Numeric bottom keypad.
* **Validation:**
  * Re-enter PIN confirmation step.
  * Blocks common sequential codes (`1234`, `0000`).

---

### **Screen 6: Role Selection (`Onboarding-10.png`)**
* **UI Elements:**
  * Headline: *"How will you use Sendalli?"*
  * Subtitle: *"You can change or add roles later from your profile."*
* **3 Interactive Cards:**
  1. **Sender (Merchant):**
     * Title: *"Send Parcels"*
     * Description: *"I want to send packages across town on keke routes."*
  2. **Rider (*Keke* / Minibus Operator):**
     * Title: *"Deliver Along Route"*
     * Description: *"I drive a commercial transit route and want to earn extra carrying small packages."*
  3. **Drop Hub (Roadside Shop):**
     * Title: *"Roadside Drop Hub"*
     * Description: *"I own a store, pharmacy, or kiosk and want to store packages for fees."*

---

## **4. Progressive Profiling by Role**

### **Branch A: Sender Setup (Target: 15 Seconds)**
1. **Input:** Business or Shop Name (Optional: street address / landmark).
2. **Permission Modal (`Modal - Location-1.png`):** Prompt for **Push Notifications** explaining: *"Get live arrival countdowns and pickup alerts"*.
3. **Completion Modal (`Modal - Location-2.png`):** *"Profile Completed!"* $\rightarrow$ Direct to Sender Dashboard.

---

### **Branch B: Rider Setup (Grassroots Vetting Flow)**
1. **Driver Selfie (`Onboarding-8.png` & `Onboarding-9.png`):**
   * Camera viewfinder modal guiding face visibility.
   * Preview screen with "Retake" or "Use Photo".
2. **Vehicle Details:**
   * Tricycle / Minibus Plate Number input.
3. **Corridor & Union Affiliation:**
   * Primary Corridor selector (e.g., *Refinery Road – Jakpa*, *Effurun Roundabout – PTI Road*).
   * Local Union Park Name & Chairman's Name.
4. **Baseline Trust Score:** System initializes score at **80/100** (*Pioneer Verified*).
5. **Permission Modal (`Modal - Location-3.png`):** Prompt for **Location Access** explaining: *"Required to broadcast orders matching your active transit corridor"*.
6. **State:** Account set to active pilot status $\rightarrow$ Direct to Rider Dashboard.

---

### **Branch C: Drop Hub Setup (Storefront Onboarding)**
1. **Store Details:** Shop Name, Category (Chemist, Provision, Electronics), and nearest roadside landmark.
2. **Storefront Photo:** Single camera capture of the shop exterior from the road.
3. **Operating Hours:** Select opening and closing times (ensures riders never divert to closed shops).
4. **State:** Hub registered $\rightarrow$ Direct to Hub Custody Dashboard.

---

## **5. Edge Cases & Resilience Strategy**

| Scenario / Edge Case | System Solution |
| :--- | :--- |
| **Phone number already registered** | Automatically redirect user to the **PIN entry** screen rather than throwing a blocking validation error. |
| **SMS OTP delayed or blocked (DND)** | 60-second timer displays a prominent **"Send OTP via WhatsApp"** button. |
| **App closed mid-registration** | Form progress is continuously cached in local secure storage; reopening the app returns to the exact pending step. |
| **Poor 2G/3G network during photo upload** | Image compression before upload (max 300KB); background retry worker prevents screen freezing. |
| **Receiver enters wrong Tracking ID** | Clear feedback modal: *"Tracking ID not found. Please double-check with the sender."* with a direct WhatsApp contact helper. |

---

## **6. Flutter Implementation Checklist**

- [ ] **Step 1: Core Setup**
  - [ ] Configure asset paths for `01_Onboarding_and_Auth` images in `pubspec.yaml`.
  - [ ] Set up theme tokens (typography, colors, button styles) according to the clean, minimal aesthetic.
  - [ ] Set up local storage helpers with `flutter_secure_storage` & `hive`.

- [ ] **Step 2: Splash & Session Router**
  - [ ] Create `SplashScreen` with cold-start session verification logic.
  - [ ] Build `WelcomeScreen` (`Onboarding.png`) with actions for Get Started, Log In, and Guest Tracking.
  - [ ] Create `GuestTrackingBottomSheet` for immediate Tracking ID lookup.

- [ ] **Step 3: Registration Steps**
  - [ ] `NameInputScreen` (`Onboarding-1.png`) with validation.
  - [ ] `PhoneInputScreen` (`Onboarding-2.png`) with `+234` formatting and auto-strip.
  - [ ] `OtpVerificationScreen` (`Onboarding-3.png`) with auto-read and WhatsApp fallback countdown.
  - [ ] `CreatePinScreen` (`Onboarding-6.png`) with custom numeric keypad.

- [ ] **Step 4: Role Branching & Progressive Setup**
  - [ ] `RoleSelectionScreen` (`Onboarding-10.png`) with 3 selectable cards.
  - [ ] `SenderProfileSetupScreen` with business name input.
  - [ ] `RiderProfileSetupScreen` with selfie capture, plate number, and corridor dropdown.
  - [ ] `HubProfileSetupScreen` with shop name, landmark, and storefront photo capture.

- [ ] **Step 5: Permissions & Success Dialogs**
  - [ ] Reusable permission dialogs for Notifications (`Modal - Location-1.png`) and Location (`Modal - Location-3.png`).
  - [ ] `ProfileCompletedModal` (`Modal - Location-2.png`) routing to the respective role's dashboard.
