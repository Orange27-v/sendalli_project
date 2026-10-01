# **Sendalli: Autonomous Rider Trust Score & Reliability System (Decoupled from Park Chairmen)**

## **1\. Objective & Philosophy**

While park chairmen provide vital grassroots vetting for initial onboarding, relying solely on human gatekeepers creates bottlenecks, introduces subjective bias, and fails to continuously measure day-to-day operational integrity.

This document outlines an **Autonomous Rider Trust Score System** for Sendalli. It operates purely on algorithmically tracked in-app behavior, timestamps, and verifiable delivery milestones, ensuring that a rider's standing, tier, and access to high-value parcels are governed by objective performance rather than human politics.

---

## **2\. Core Scoring Architecture**

* **Scale Range:** 0 to 100 points.  
* **Starting Score:** Every newly approved rider begins with a baseline score of **80/100** (a "Pioneer Verified" standing).  
* **Dynamic Recalculation:** The score is recalculated automatically in real-time via Laravel event listeners or queued jobs in MySQL every time a parcel delivery lifecycle event concludes.

---

## **3\. Point Allocation Matrix (Actions & Penalties)**

### **A. Positive Reinforcement (Points Added)**

* **Successful Standard Delivery:** Completed within the estimated corridor window with valid pickup scan and receiver 6-digit code release. **(+1 point)**  
* **Lightning Acceptance & Pickup:** Accepting a broadcast alert within 2 minutes and completing the roadside pickup scan under 3 minutes. **(+2 points)**  
* **Zero-Dispute Streak:** Completing 10 consecutive deliveries without a single merchant or receiver complaint. **(+5 bonus points)**  
* **Hub Cooperation:** Successfully dropping off a missed-window parcel at a designated Drop Hub cleanly within the grace period. **(+2 points)**

### **B. Negative Adjustments (Points Deducted)**

* **Post-Acceptance Cancellation:** Dropping an accepted delivery after tapping "Accept" (forces the system to re-broadcast). **(-5 points)**  
* **Late / Missed Roadside Handoff:** Failing to meet the receiver at the designated roadside drop point, forcing a fallback diversion to a Drop Hub. **(-3 points)**  
* **Mismatched Parcel Report:** A rider rejects a parcel at pickup due to photo/item mismatch (minor penalty if verified, to discourage blind accepting). **(-2 points)**  
* **Active Dispute / Damage / Tampering Claim:** A merchant or receiver files a verified claim regarding damaged, missing, or tampered goods. **(-20 points)**

---

## **4\. Trust Score Tiers & App Privileges**

The trust score directly dictates what a rider can access within the Flutter app, creating a gamified incentive structure for high performance:

| Score Range | Tier Designation | Operational Privileges & Restrictions |
| :---- | :---- | :---- |
| **90 – 100** | **Elite / Priority Partner** | • First refusal on high-value (up to ₦20,000 cap) and express-fee parcels. • Faster same-day payout processing priority. |
| **75 – 89** | **Standard Operator** | • Standard corridor broadcast matching. • Standard payout schedule. |
| **60 – 74** | **Watchlisted / Restricted** | • Restricted to lower-value parcels. • Temporary throttle on broadcast frequency until score recovers. |
| **Below 60** | **Automated Suspension** | • Account automatically flagged and suspended. • Requires manual system review or re-verification to clear. |

---

## **5\. Automated Dispute & Grace Mechanisms**

To protect honest riders from malicious false claims, the system builds in safeguards:

* **The Grace Buffer:** A single negative claim does not instantly ban a rider; the sliding score absorbs minor friction while triggering an automated warning notification in their Flutter dashboard.  
* **Evidence Weighting:** If a dispute is filed, the Laravel backend cross-references timestamps: did the rider scan the Pickup QR? Did they take a delivery photo? If digital proof exists, the penalty weight is halved or dismissed during automated arbitration.  
* **Appeals Workflow:** Suspended riders can submit an in-app photo or text appeal, which feeds into the Laravel Filament admin control panel for review, completely bypassing the need to loop in park chairmen for operational penalties.