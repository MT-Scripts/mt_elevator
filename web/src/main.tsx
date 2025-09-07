import React from 'react';
import ReactDOM from 'react-dom/client';
import { VisibilityProvider } from './providers/VisibilityProvider';
import './index.css';
import Elevator from './components/Elevator';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <VisibilityProvider>
      <Elevator />
    </VisibilityProvider>
  </React.StrictMode>,
);
