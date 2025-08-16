import { useState } from 'react';
import { AuthProvider, useAuth } from './lib/auth.jsx';
import LoginPage from './components/LoginPage';
import Layout from './components/Layout';
import Dashboard from './components/Dashboard';
import './App.css';

// Placeholder components for other pages
const SalonsPage = () => <div className="p-6"><h1 className="text-2xl font-bold">Salons Management</h1><p className="text-gray-600 mt-2">Coming soon...</p></div>;
const VisitsPage = () => <div className="p-6"><h1 className="text-2xl font-bold">Visits Management</h1><p className="text-gray-600 mt-2">Coming soon...</p></div>;
const OrdersPage = () => <div className="p-6"><h1 className="text-2xl font-bold">Orders Management</h1><p className="text-gray-600 mt-2">Coming soon...</p></div>;
const AnalyticsPage = () => <div className="p-6"><h1 className="text-2xl font-bold">Analytics</h1><p className="text-gray-600 mt-2">Coming soon...</p></div>;
const ProfilePage = () => <div className="p-6"><h1 className="text-2xl font-bold">Profile</h1><p className="text-gray-600 mt-2">Coming soon...</p></div>;

const AppContent = () => {
  const { isAuthenticated, loading } = useAuth();
  const [currentPage, setCurrentPage] = useState('dashboard');

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />;
      case 'salons':
        return <SalonsPage />;
      case 'visits':
        return <VisitsPage />;
      case 'orders':
        return <OrdersPage />;
      case 'analytics':
        return <AnalyticsPage />;
      case 'profile':
        return <ProfilePage />;
      default:
        return <Dashboard />;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <LoginPage />;
  }

  return (
    <Layout currentPage={currentPage} onNavigate={setCurrentPage}>
      {renderPage()}
    </Layout>
  );
};

function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  );
}

export default App;

