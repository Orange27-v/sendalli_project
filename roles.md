That distinction makes the receiver experience **infinitely better and friction-free**.

Forcing a recipient to sign up for an account, set a password, or verify an OTP just to track a single package would kill adoption. A **temporary session powered by a Tracking ID** respects the receiver's time while giving them all the digital benefits without the onboarding drag.

Here is how the **Temporary Receiver Tracking Login** works cleanly within your architecture:

## 1. How the Temporary Receiver Login Works

* **The Shared Link / ID:** When a merchant books a parcel, the system generates a unique **Tracking ID** (and a direct web/app deep-link). The merchant shares this via WhatsApp or text alongside the drop point and time.
* **Frictionless Entry:** The receiver opens the app (or a lightweight web view), types in or pastes the Tracking ID (e.g., `SND-WAR-8492`), and instantly enters a temporary tracking session. No password, no registration, no SMS OTP required.
* **What They See in the Temporary Session:**
* Live status indicator (*Booked $\rightarrow$ Picked up by Rider $\rightarrow$ In Transit $\rightarrow$ Arrived at Hub*).
* Countdown timer or estimated arrival at the roadside drop point.
* The rider's details and phone number for direct contact if needed.
* The 6-digit verification code or QR display for the handoff.
* Details of the ₦500 Drop Hub fee if they choose or need to route it to a micro-hub.



## 2. Technical Implementation in Laravel, MySQL & Flutter

* **Stateless Guest Tracking Endpoint:** In Laravel, instead of requiring an authenticated user token for the receiver, a dedicated public tracking API endpoint permits fetching a specific delivery record from MySQL *only* when querying with the exact, valid Tracking ID.
* **Temporary Local Storage:** The Flutter app caches the active Tracking ID locally in secure storage/Hive so the receiver can close and reopen the app without re-typing it while their package is active. Once the delivery status hits `Completed`, the temporary session expires and clears automatically.

This keeps the receiver experience completely frictionless—just like tracking a package on a major courier site, but optimized for low-end Android devices and local transit corridors!