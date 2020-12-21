import './style.css';
import { Nav } from '../../components/';

export function Source() {
    document.location.href = 'https://github.com/Alpha-Serpentis-Developments/Project-Sharing'

    return (
        <div id="source-container">
            <Nav />
            <h1>Redirecting you...</h1>
        </div>
    );
}
