import { Link } from 'react-router-dom'

export function NavLink(props) {
    return (
        <li>
            <Link to={props.href}>{props.children}</Link>
        </li>
    )
}
