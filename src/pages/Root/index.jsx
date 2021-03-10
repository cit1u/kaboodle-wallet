import { Box } from '../../components/';

export function Root() {
    import('./style.css');

    return (
        <div id="root-container">
            <div className="container">
            <Box title="Project Sharing"><p>Sharing is caring</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            </div>
        </div>
    );
}
