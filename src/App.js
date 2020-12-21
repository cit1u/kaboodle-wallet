import React from 'react';
import { Switch, Route } from 'react-router-dom';
import './App.css';
import { Root } from './pages/';

function App() {
    return (
        <div id="app-mount">
            <Switch>
                <Route path="/" exact={true} component={Root} />
            </Switch>
        </div>
    );
}

export default App;
