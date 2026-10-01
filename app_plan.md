# **Sendalli Master Application & Implementation Plan**

## **1. Executive Summary & Architecture Overview**

**Sendalli** is an asset-light, corridor-based transit-logistics platform built specifically for secondary Nigerian cities (starting in Warri and Effurun, Delta State). It enables commercial tricycles (*kekes*) and minibuses to carry small, standardized, sealed parcels along fixed routes without making detours, cutting delivery costs from ₦1,500–₦2,000 down to ₦200–₦600 fare-anchored prices.

### **Core Technology Stack**
* **Frontend Mobile Application:** **Flutter** (Single unified app featuring role-switched experiences for Sender, Rider, Hub, and Receiver guest session, optimized for low-end 2GB RAM Android devices).
* **Backend API & Logic:** **Laravel 11+ & MySQL 8.0+** (Sanctum authentication, transactional escrow ledger with strict ACID guarantees, and queue workers for asynchronous tasks).
* **Realtime Engine:** **Laravel Reverb** (First-party WebSockets for live corridor alerts, radar matching, and receiver countdown timers).
* **Admin & Operations Panel:** **Filament PHP v3** (Integrated directly into the Laravel backend for rider vetting, dispute arbitration, escrow audits, and corridor metrics).
* **Third-Party Integrations:** **Paystack** (In-app escrow and same-day bank payouts) and **Termii** (High-delivery Nigerian SMS OTPs).

---

## **2. The 4-Role User Architecture**

```
┌────────────────────────────────────────────────────────────────────────┐
│                        SENDALLI SINGLE FLUTTER APP                     │
├─────────────────┬───────────────────┬──────────────────┬───────────────┤
│  SENDER (Shop)  │   RIDER (Keke)    │    HUB (Store)   │   RECEIVER    │
│ • Post parcels  │ • Go "On Route"   │ • Custody intake │ • Guest track │
│ • Escrow funding│ • 1-tap accept    │ • ₦500 hub fee   │ • 6-digit OTP │
│ • Pickup QR gen │ • Pickup QR scan  │ • Secure release │ • No signup   │
│ • Track delivery│ • 6-digit code in │ • Ledger balance │ • Contact info│
└─────────────────┴───────────────────┴──────────────────┴───────────────┘
```

1. **Sender (Merchant / Customer):** Fast business profile, posts parcel with mandatory photo, selects corridor drop point, deposits fee into escrow, and shares 6-digit code.
2. **Rider (*Keke* Driver):** Approved via union park chairman, goes "On Route", receives corridor alerts, makes quick 1-minute roadside pickup/drop stops, and earns instant wallet credit.
3. **Hub (Micro-Store Operator):** Roadside shop/chemist that accepts parcels when receivers miss roadside windows or pre-book custody, earning a flat **₦500 custody fee**.
4. **Receiver (Frictionless Guest):** Accesses a temporary in-app tracking session using only a **Tracking ID** (`SND-WAR-XXXX`) without passwords or account registration.

---

## **3. Screen-by-Screen UI/UX Mapping**

Based on the design assets organized in `Ride Sharing App - Rider App/`:

### **Module 1: Onboarding & Authentication (`01_Onboarding_and_Auth/`)**
* **Splash & Value Prop (`Onboarding.png`):** Brand introduction with two primary routes: "Get Started" or "Track a Package" (Instant guest tracking).
* **Identity & Phone (`Onboarding-1.png`, `Onboarding-2.png`):** Full name and Nigerian mobile number (`+234`).
* **Termii SMS OTP (`Onboarding-3.png`):** 4 to 6-digit verification code with clipboard autofill and 60-second WhatsApp fallback timer.
* **Security PIN (`Onboarding-6.png`):** 4-digit keypad PIN for rapid, low-friction login tailored for local merchants and drivers.
* **Role Selection (`Onboarding-10.png`):** "How will you use Sendalli?"
  * *Sender:* Quick shop name entry $\rightarrow$ Direct to Sender Dashboard.
  * *Rider:* Driver selfie (`Onboarding-8.png`, `Onboarding-9.png`), vehicle plate number, corridor and union park selection $\rightarrow$ Verification pending.
  * *Hub:* Store name, roadside storefront photo, and operating hours.
* **Permissions (`Modal - Location-1.png` to `3.png`):** Contextually triggered modals for Push Notifications (broadcast alerts), Location (corridor matching), and Camera (parcel/selfie photos).

### **Module 2: Home & Role Dashboards (`02_Home_and_Dashboard/`)**
* **Rider Dashboard (`Home.png`, `Home-1.png`):** "Go On Route" toggle switch, active corridor selector, today's earnings card, and **Trust Score badge** (e.g., *Trust Score: 94% - Elite Partner*).
* **Sender Dashboard (`Home-2.png`):** Quick "Send Parcel" CTA, active shipments carousel, and recent corridor routes.
* **Corridor Drop Points Search (`Home-4.png`):** Quick-select search sheet for standardized roadside landmarks (e.g., *Refinery Junction, PTI Gate, Jakpa Junction*).

### **Module 3: Location, Corridor & Booking (`03_Location_and_Booking/`)**
* **Origin & Destination (`Location.png` to `Location-5.png`, `switch-vertical-02.png`):** Fixed corridor drop-point selection with distance and fare-anchored price calculation.
* **Date & Scheduling (`Date.png`):** Immediate dispatch vs. scheduled transit wave.
* **Parcel Details & Size (`Modal.png`, `Modal-1.png`, `Modal-2.png`):** Size limits (must fit on lap or under seat), value cap declaration (max ₦20,000), mandatory parcel photo, and receiver phone number.

### **Module 4: Matching & Corridor Broadcast (`04_Finding_and_Matching/`)**
* **Radar Corridor Matching (`Finding a Ride-3.png`):** Dynamic polling/WebSocket listener matching only riders currently "On Route" along that corridor.
* **Job Alert Card (`Finding a Ride.png`, `Finding a Ride-1.png`):** Rider sees pickup landmark, drop point, parcel photo, and net earnings.
* **Acceptance & Confirmation (`Finding a Ride-4.png` to `6.png`, `Frame 7021.png`):** First-come-first-served 1-tap accept. Paystack escrow locks funds immediately.

### **Module 5: Active Trips & Live Tracking (`05_Active_Trips_and_Tracking/`)**
* **Pickup Scan:** Rider stops at merchant roadside, verifies parcel against photo, and scans Merchant Pickup QR.
* **Live Route & Countdown (`Trip details.png` to `4.png`):** Real-time arrival estimation ("Arriving at Jakpa in 12 minutes"). Receiver alerted via in-app countdown and automated SMS.
* **Roadside Handoff & Release:** 1 to 2-minute roadside stop. Receiver reads out 6-digit release code. Rider inputs code and captures quick handover photo.
* **Fallback to Drop Hub:** If receiver is not at the roadside within 1 minute, the app redirects parcel to the nearest partner Drop Hub (`Frame 7018.png` Golden Rules enforcement).

### **Module 6: Payments, Ledger & Escrow (`07_Payments_and_Wallet/`)**
* **Wallet Balance (`Payment.png`):** Tracks Available Balance, In-Escrow Funds, and Total Earned.
* **Instant Payouts:** Riders initiate same-day bank transfers via Paystack Transfer API once deliveries conclude.

### **Module 7: Ratings, Reviews & Appeals (`08_Ratings_and_Reviews/`)**
* **Post-Trip Feedback (`Frame 7076.png`, `Frame 7077.png`):** Anonymous feedback on sender/receiver punctuality and parcel packaging integrity.
* **Dispute Submission:** 30-minute window for damage or mismatch reports feeding directly into the Filament admin panel.

---

## **4. Autonomous Rider Trust Score System**

To ensure operational discipline without relying on union park chairmen for daily policing, the system runs an autonomous scoring engine in Laravel & MySQL:

* **Scale:** 0 to 100 points. Baseline starting score for approved riders: **80/100** (*Pioneer Verified*).
* **Positive Metrics:**
  * Successful standard delivery: **+1 point**
  * Fast acceptance & pickup (< 3 mins): **+2 points**
  * 10-delivery zero-dispute streak: **+5 bonus points**
  * Drop Hub cooperation: **+2 points**
* **Penalties:**
  * Post-acceptance cancellation: **-5 points**
  * Missed roadside handoff: **-3 points**
  * Mismatch rejection: **-2 points**
  * Verified dispute / damage / tampering: **-20 points**
* **Tier Governance:**
  * **90–100 (Elite Partner):** Priority dispatch on high-value (up to ₦20,000) and express parcels; top payout priority.
  * **75–89 (Standard Operator):** Standard corridor dispatch.
  * **60–74 (Watchlisted):** Throttled frequency; restricted to low-value parcels.
  * **Below 60 (Automated Suspension):** Immediate system freeze; requires Filament admin appeal review.
* **Evidence Weighting:** Timestamp cross-referencing of Pickup QR and delivery photos automatically cuts or dismisses penalties during disputes.

---

## **5. Phased Implementation Roadmap**

### **Phase 1: Lean Pilot (Weeks 1 – 4)**
* **Focus Corridor:** Single route in Warri/Effurun (**Refinery Road to Jakpa**).
* **Scope:** 10 union-vetted riders, 10 registered merchants.
* **Features Included:**
  * Phone OTP Auth & PIN login.
  * Merchant post parcel with photo & fixed fare bands (₦200–₦600).
  * Paystack Escrow & rider wallet credit.
  * Rider corridor alerts & 1-tap accept.
  * Roadside Pickup QR + Receiver 6-digit release code.
  * Baseline Trust Score logging.
  * Filament admin panel for user verification and escrow monitoring.
* **Features Excluded:** Dynamic price bidding, public ads, merchant recurring subscriptions.

### **Phase 2: Network Density & Hub Expansion**
* Full Drop Hub network integration (₦500 custody fee model).
* Automated WhatsApp Business API notification triggers.
* Multi-corridor scaling (PTI Road, Airport Road, Enerhen Junction).

### **Phase 3: Scale & Advanced Monetization**
* Hyper-local product discovery ad listings for roadside shops.
* Tiered verification (NIN/BVN lookups) unlocking higher parcel value caps.
* InDrive-style counter-offer price negotiation engine.

---

## **6. Code Standards & Production Rules**
1. **Production-Ready:** No temporary hacks, dummy credentials, or console leftovers.
2. **Type Safety:** Strict typing throughout Flutter (Dart) and Laravel (PHP 8.3+ with strict types); no `any` types.
3. **ACID Ledger Integrity:** All wallet balance changes and escrow transitions must use `DB::transaction` and database row-level locking (`lockForUpdate`).
4. **Resilience:** Offline retry queues in Flutter for poor connectivity along transit routes.
