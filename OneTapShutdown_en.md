# One-tap Shutdown · Privacy policy

**Effective date and last updated:** 2026-10-13  
**Developer:** MRongM  
**Android package:** `com.mrongm.shutdown`  
**Contact:** [jiangisright@gmail.com](mailto:jiangisright@gmail.com)

A local Android utility for shutdown and restart. No app account, advertising, analytics, or app-operated server receives your personal data.

## 1. Scope and app behavior

This policy applies to **One-tap Shutdown**, also named **一键关机** in Simplified Chinese, published by **MRongM**, with Android package `com.mrongm.shutdown`. It describes the app’s behavior, local technical information, and the separate processing involved when you use external websites or contact the developer.

The app provides shutdown and restart controls. After you authorize it through Shizuku and explicitly choose a power action, the app executes that action immediately through a local service. Your phone’s existing power button and system power menu remain usable.

## 2. Data access, collection, and sharing

The app does not collect, upload, sell, or share personal data through its app functions. It has no app accounts, advertisements, in-app purchases, analytics SDKs, remote crash reporting, or app-operated backend database. It does not access contacts, photos, messages, device location, or advertising identifiers.

The app does not request Internet, storage, or accessibility permissions. It checks whether the specific Shizuku package `moe.shizuku.privileged.api` is installed and reads local authorization and service connection status. This targeted package query is not a scan, collection, or upload of your installed-app inventory.

One-tap Shutdown is a paid app distributed through Google Play. Google Play processes the store purchase under its own terms and privacy practices. The app itself does not receive your payment-card number or payment details and has no in-app purchase or payment SDK.

## 3. Local authorization and power commands

Purchasing the app does not grant Android or Shizuku permissions and does not install or activate Shizuku. You still need to complete the separate installation, activation, and authorization steps.

Shizuku is a separate app that you install and activate. Shizuku authorization grants privileged local execution as root or Android shell. This app’s implementation uses that capability only for fixed shutdown and restart actions and does not access your contacts, photos, or location. The service checks that it runs as root (UID 0) or Android shell (UID 2000), then executes the fixed shutdown or restart command you selected. The app does not offer arbitrary user-entered commands.

On a device without root, Shizuku must be activated again after each device boot, using a computer with ADB or the phone’s wireless debugging feature. Once activation succeeds, the USB connection can be disconnected. Rooted devices can start Shizuku using root. Activation, debugging, and Shizuku’s own permissions are controlled by Android and Shizuku.

## 4. Local information, retention, and deletion

Technical status, the selected power operation, service UID, and error details may appear in local Android diagnostic logs or app error messages. The app does not send these diagnostics to a server or maintain a separate user database. Android manages system-log access, retention, and clearing. Your app-language preference is saved by Android; the app does not upload it.

You can revoke this app’s authorization in Shizuku. Uninstalling the app removes its app-local state under Android’s normal app-removal behavior. Android manages system-held preferences and diagnostics. Uninstalling this app does not uninstall Shizuku, revoke permissions granted to other apps, or delete information already held by independent services.

There is no app account or server-side app personal database to delete. For deletion requests concerning support emails, see section 7.

## 5. Shizuku, external links, and this policy website

Shizuku has its own behavior, authorization records, and privacy practices. Consult its [official website and documentation](https://shizuku.rikka.app/) before installing or activating it. MRongM does not control Shizuku’s independent data handling.

The app’s Shizuku download link opens an external browser. Opening a download site or this policy page lets that browser, website, and hosting services process ordinary web connection information, such as IP address, request path, and request time, under their own practices. This policy website is hosted using GitHub Pages. Website hosting logs are separate from app telemetry; the app itself does not upload diagnostic logs or personal data to this website.

The app does not embed a browser or add tracking parameters to its download link. External browser, Android, Shizuku, and hosting behavior is governed by the respective provider.

## 6. Security

Power actions remain on your device and require Shizuku authorization. Because these actions can immediately shut down or restart the phone, use them only when you intend to do so, and keep Android and Shizuku updated. Local diagnostic information is subject to Android’s protections. No device or software environment can be guaranteed absolutely secure.

## 7. Contact and support correspondence

The developer responsible for this app is **MRongM**. For privacy questions or requests, email [jiangisright@gmail.com](mailto:jiangisright@gmail.com).

If you voluntarily email the developer, the developer receives your email address, message, and any attachments you choose to provide, and uses them to handle your request. This correspondence is separate from automatic app data collection and is processed through the email service. It is retained as needed to address the inquiry and meet applicable retention obligations. You may request deletion of this correspondence; independent email providers may retain information under their own policies.

## 8. Policy changes

This policy may be updated if the app’s behavior or applicable requirements change. The date at the top identifies this revision. Material changes will be reflected in this policy and the app or store listing when required.
