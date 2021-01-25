import React from 'react';
import { Switch, Route } from 'react-router-dom';
import './App.css';
import { Root, Deploy, Configure, Source } from './pages/';
import { Nav } from './components/';

function App() {
    return (
        <div id="app-mount">
            <Nav />
            <Switch>
                <Route path="/" exact={true} component={Root} />
                <Route path="/deploy" exact={true} component={Deploy} />
                <Route path="/configure" exact={true} component={Configure} />
                <Route path="/source" exact={true} component={Source} />
            </Switch>
        </div>
    );
}

export default App;
