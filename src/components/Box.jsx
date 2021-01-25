export function Box(props) {
    if (typeof props.title === 'undefined') {
        return (
            <div className="box">
                <div className="box-contents">{props.children}</div>
            </div>
        )
    } else {
        return (
            <div className="box">
                <h1 className="box-title">{props.title}</h1>
                <div className="box-contents">{props.children}</div>
            </div>
        )
    }
}
