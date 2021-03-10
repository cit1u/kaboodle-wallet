import { Box } from '../../components/';

export function Root() {
    import('./style.css');

    return (
        <div id="root-container">
            <div className="container">
            <Box title="Project Sharing"><p className="text-center">Sharing is caring</p></Box>
            <Box><p>Seems like you don't have a wallet connected <a href="/connect" className="connect">Connect Wallet</a></p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            </div>
        </div>
    );
}
