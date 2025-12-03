const Support = () => {
    return (
        <div className="min-h-screen bg-gray-50 px-6 py-12">
            <div className="max-w-4xl mx-auto bg-white shadow-md rounded-xl p-8">

                {/* Title */}
                <h1 className="text-4xl font-bold text-blue-900 mb-8 text-center">
                    Budget Tracker App Support
                </h1>

                {/* Introduction */}
                <section className="mb-6">
                    <p className="text-blue-800 leading-relaxed">
                        Welcome to the Budget Tracker App Support page. Here you can find help
                        on managing your income, expenses, and budgets effectively.
                    </p>
                </section>

                {/* Account Registration & Login */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">
                        1. Account Registration & Login
                    </h2>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Create an account using your email and password.</li>
                        <li>Login to access your financial data from any device.</li>
                        <li>Your data is securely synchronized with your account.</li>
                    </ul>
                </section>

                {/* Managing Income & Expenses */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">
                        2. Managing Income & Expenses
                    </h2>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Add income and expense records with amount, date, and category.</li>
                        <li>Edit or delete inaccurate entries anytime.</li>
                        <li>Label transactions for better organization.</li>
                    </ul>
                </section>

                {/* Budget & Reports */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">
                        3. Budget & Reports
                    </h2>
                    <ul className="list-disc list-inside text-blue-800 space-y-1">
                        <li>Set monthly budgets for each category.</li>
                        <li>Track how much money you have left.</li>
                        <li>Generate reports and download summaries.</li>
                    </ul>
                </section>

                {/* FAQ */}
                <section className="mb-6">
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">
                        4. Frequently Asked Questions
                    </h2>
                    <div className="text-blue-800 leading-relaxed space-y-3">

                        <div>
                            <p><strong>Q: How do I add income?</strong></p>
                            <p>A: Go to "Add Transaction" and select "Income".</p>
                        </div>

                        <div>
                            <p><strong>Q: Can I set a budget?</strong></p>
                            <p>A: Yes, you can create monthly budgets in the Budget section.</p>
                        </div>

                        <div>
                            <p><strong>Q: What happens if I exceed my budget?</strong></p>
                            <p>A: The app will notify you when you approach or exceed your limit.</p>
                        </div>

                    </div>
                </section>

                {/* Contact Support */}
                <section>
                    <h2 className="text-2xl font-semibold text-blue-900 mb-3">
                        5. Contact Support
                    </h2>
                    <p className="text-blue-800 leading-relaxed">
                        If you need further help, contact us at:
                        <a
                            href="mailto:anhongoc1306@gmail.com"
                            className="text-blue-600 underline ml-1"
                        >
                            anhongoc1306@gmail.com
                        </a>
                    </p>
                </section>

            </div>
        </div>
    );
};

export default Support;