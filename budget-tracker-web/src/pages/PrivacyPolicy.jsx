export default function PrivacyPolicy() {
    return (
        <div className="min-h-screen bg-gray-50 px-6 py-12">
            <div className="max-w-4xl mx-auto bg-white shadow-md rounded-xl p-8">

                {/* Title */}
                <h1 className="text-4xl font-bold text-blue-900 mb-8 text-center">
                    Privacy Policy
                </h1>

                {/* Introduction */}
                <section className="mb-6">
                    <p className="text-blue-800 leading-relaxed">
                        Welcome to our Personal Finance Tracker App. Your privacy is very important to us.
                        This Privacy Policy explains how we collect, use, and protect your information
                        when you use our application. By using the app, you agree to this policy.
                    </p>
                </section>

                {/* Data Collection */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">1. Data Collection</h2>
                    <p className="text-blue-800 leading-relaxed mb-2">
                        We may collect the following information:
                    </p>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Account information (email, username)</li>
                        <li>Financial data (income, expenses, categories, notes)</li>
                        <li>App activity data to improve performance</li>
                        <li>Device and log information for security purposes</li>
                    </ul>
                </section>

                {/* Use of Data */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">2. How We Use Your Data</h2>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Manage and display your finances accurately</li>
                        <li>Create charts and financial summaries</li>
                        <li>Improve app usability</li>
                        <li>Provide support and troubleshooting</li>
                        <li>Ensure system security</li>
                    </ul>
                </section>

                {/* Third-Party Services */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">3. Third-Party Services</h2>
                    <p className="text-blue-800 leading-relaxed">
                        We may use trusted third-party services for:
                    </p>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Authentication</li>
                        <li>Cloud data storage</li>
                        <li>Error tracking</li>
                        <li>App performance analytics</li>
                    </ul>
                    <p className="text-blue-800 mt-2">
                        We do not sell or share your personal information for marketing purposes.
                    </p>
                </section>

                {/* Data Security */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">4. Data Security</h2>
                    <p className="text-blue-800 leading-relaxed">
                        Your information is protected using secure technology. However, you are also
                        responsible for keeping your account credentials confidential.
                    </p>
                </section>

                {/* User Rights */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">5. Your Rights</h2>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>View, edit, or delete your data</li>
                        <li>Request full data removal</li>
                        <li>Disable notifications</li>
                        <li>Download data reports (if supported)</li>
                    </ul>
                </section>

                {/* Contact */}
                <section>
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">6. Contact Us</h2>
                    <p className="text-blue-800 leading-relaxed">
                        For privacy-related questions, contact us at:
                        <a href="mailto:anhongoc1306@gmail.com" className="text-blue-600 underline ml-1">
                            anhongoc1306@gmail.com
                        </a>
                    </p>
                </section>

            </div>
        </div>
    );
}