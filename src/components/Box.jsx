export function Box(props) {
    if (typeof props.title === 'undefined') {
        return (
            <div className="box">
                <div className="box-contents">{props.children}</div>
            </div>
        )
    } else {
        return (
            <div className="box box-with-title">
                <div className="box-body">
                    <h1 className="box-title">{props.title}</h1>
                    <div className="box-contents">{props.children}</div>
                </div>
            </div>
        )
    }
}
