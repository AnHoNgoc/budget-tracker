export default function Home() {
    return (
        <div className="min-h-screen bg-blue-50 flex flex-col items-center justify-center px-4 py-12">

            {/* Title */}
            <h1 className="text-4xl md:text-5xl font-bold text-blue-900 mb-4 text-center">
                Budget Tracker App
            </h1>

            {/* Description */}
            <p className="text-center text-blue-800 max-w-xl mb-12">
                Take full control of your money. Track your income and expenses,
                manage your budget, and analyze your financial habits in one place.
            </p>

            {/* Features */}
            <div className="max-w-4xl w-full grid grid-cols-1 md:grid-cols-2 gap-6 text-blue-900">

                {/* Feature 1 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Income Tracking</h3>
                    <p>Record and manage your income sources easily.</p>
                </div>

                {/* Feature 2 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Expense Management</h3>
                    <p>Add, edit, and categorize your daily expenses.</p>
                </div>

                {/* Feature 3 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Budget Planning</h3>
                    <p>Set monthly budgets and control your spending.</p>
                </div>

                {/* Feature 4 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Financial Statistics</h3>
                    <p>View charts and summaries of your financial activity.</p>
                </div>

                {/* Feature 5 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Secure Data</h3>
                    <p>Your financial information is protected and stored safely.</p>
                </div>

                {/* Feature 6 */}
                <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
                    <h3 className="text-xl font-semibold mb-2">Smart Reports</h3>
                    <p>Generate financial reports anytime for better insight.</p>
                </div>

            </div>
        </div>
    );
}