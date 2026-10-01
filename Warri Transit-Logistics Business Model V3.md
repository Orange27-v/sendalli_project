# **Sendalli Master Blueprint & Business Model V3.1 (Expanded Multi-Role & Tech Architecture)**

## **1\. Executive Summary & Core Philosophy**

The **Warri Transit-Logistics Network (Sendalli)** is an app-enabled hyper-local logistics model designed specifically for secondary Nigerian cities like Warri, Effurun, and environs.

* **The Core Mission:** Building the foundational infrastructure and commercial bedrock for local e-commerce by making logistics cheap, accessible, and ultra-reliable.  
* **The Operational Model:** Turning existing commercial *keke* (tricycles) and minibuses into a decentralized delivery fleet, and leveraging fixed-route corridors with **designated timer-based hub drop-offs and micro-hub fallbacks**.

---

## **2\. Problem Statement**

* **For Shoppers & Small Businesses:** Sending a package across town via traditional dedicated dispatchers costs ₦1,500–₦2,000, wiping out small purchase margins.  
* **For Transporters (*Keke* Drivers):** Rising fuel costs and empty return legs eat into daily earnings.  
* **For Courier Companies:** Door-to-door delivery suffers from inaccurate addresses, high fuel use, and wasted waiting time.

---

## **3\. The 4-Role User Ecosystem & Workflows**

### **1\. Sender (Merchant Dashboard)**

* **Onboarding & Auth:** Fast mobile phone number registration via Termii OTP.  
* **Core Actions:** Tap **"Send Parcel"**, enter description, take mandatory on-device compressed photo, set value cap (₦20,000), choose transit corridor/drop point, select roadside handoff or pre-select a Drop Hub, and pay fixed fare into escrow via Paystack \[cite: 1, 2\].  
* **Dashboard Perks:** Can apply directly via the app dashboard to turn their own shop into a verified **Drop Hub** to earn extra fees and foot traffic.

### **2\. Rider (*Keke* / Minibus Dashboard)**

* **Onboarding & Auth:** Phone number \+ OTP, selfie, plate number photo, and mandatory approval by the local park chairman \[cite: 1\].  
* **Core Actions:** Tap **"On Route"**, view live corridor alerts, accept jobs with one tap, scan merchant Pickup QR at a brief roadside stop, call receiver with countdown notice, deliver or route to a hub, and enter the 6-digit release code \[cite: 1, 2\].  
* **Trust & Safety:** Earns a dynamic **Rider Trust Score** based on speed, successful scans, and lack of disputes, ensuring elite priority routing. Same-day wallet withdrawals \[cite: 1, 2\].

### **3\. Hub (Micro-Fulfillment & Custody Dashboard)**

* **Onboarding & Auth:** Approved merchant/shop owner profile upgraded to hub status via dashboard application.  
* **Core Actions:** Scan incoming parcels (missed roadside handoffs or pre-selected hub drop-offs), store securely, and release items to receivers using the 6-digit code or tracking QR.  
* **Incentives:** Automatically logs the **₦500 Drop Hub custody/pickup fee**, crediting the hub operator's ledger.

### **4\. Receiver (Temporary Tracking Session)**

* **Onboarding & Auth:** **No account creation required.** Accessed instantly via a shared Tracking ID link sent via WhatsApp or text.  
* **Core Actions:** Paste Tracking ID to view live status updates, countdown timers, the rider's contact info, the 6-digit verification code/QR display, and options to manage the ₦500 Drop Hub fee if diverted to a secure micro-hub.

---

## **4\. Trust & Security Framework**

* **Union-Backed Driver Vetting:** Drivers are recruited exclusively through established local *keke* and minibus union branches, tying profiles directly to park leadership \[cite: 1\].  
* **Tamper-Evident Packaging:** Mandatory standardized security seals or pouches ensure any tampering is instantly flagged at handover \[cite: 1\].  
* **Escrow with Secure OTP Release:** Delivery fees are held in an in-app escrow wallet \[cite: 1\] and released automatically only after the receiver confirms pickup using a unique One-Time Password (OTP).  
* **The Gamified Pioneer Badge System:** Initial cohorts of drivers and hub operators earn visible "Pioneer Verified" status, driving priority routing and establishing trust \[cite: 1\].

---

## **5\. Monetization Strategy (Ad-Driven & Commission-Based)**

* **Core Platform Commission:** A modest 10% platform service charge per delivery route.  
* **Hyper-Local Product Discovery Ad Spots:** Merchants buy promoted photo and text listings inside the customer app featuring direct-dial phone numbers and WhatsApp buttons.  
* **Express / Priority Slots:** Optional micro-fees for users wanting parcels prioritized on the next transit wave.  
* **Drop Hub Fees:** ₦500 custody fee for hub-based pickups or missed roadside handoffs.

---

## **6\. Technical Architecture & Tech Stack**

* **Frontend Mobile App:** **Flutter** (Single unified app featuring role-based dashboards for Sender, Rider, Hub, and Receiver) optimized for low-end 2GB RAM Android devices with on-device image compression and offline retry queues.  
* **Backend & Database:** **Laravel & MySQL** (Laravel REST API with Sanctum, Auth via Termii OTP, MySQL database, and **Laravel Reverb** WebSocket server for real-time status updates and arrival timers).  
* **Payments & Escrow:** **Paystack** integrated alongside a custom internal ledger table for escrow management and same-day payouts.  
* **Admin Control:** **Filament PHP** (integrated directly into Laravel) for manual dispute handling, rider approvals, escrow audits, and corridor monitoring.