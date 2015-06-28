var ReactModal = React.createClass({
    getInitialState: function () {
        return {show: false};
    },
    componentDidMount: function () {
        this.setState({show: true});
    },
    hideModal: function () {
        this.setState({show: false});
    },
    render: function () {
        var rawBodyContent = this.props.bodyContent;
        var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;
        return (
            <ReactCSSTransitionGroup transitionName="show">
                {this.state.show ? [
                    <div className='react-modal-container' key={Math.random()}>
                        <div className='react-modal'>
                            <div className={'react-modal-content '+(!_.isNull(this.props.additionalClasses) ? this.props.additionalClasses['content'] : '')}>
                                <div className={'react-modal-header '+(!_.isNull(this.props.additionalClasses) ? this.props.additionalClasses['header'] : '')}>
                                    <button type='button' className='close' aria-label='Close'
                                            onClick={this.hideModal}>
                                        <span aria-hidden='true'>×</span>
                                    </button>
                                    <h4 className={'react-modal-title '+(!_.isNull(this.props.additionalClasses) ? this.props.additionalClasses['title'] : '')}>
                                        {this.props.headerTitle}
                                    </h4>
                                </div>
                                <div className={'react-modal-body '+(!_.isNull(this.props.additionalClasses) ? this.props.additionalClasses['body'] : '')}>
                                    <span dangerouslySetInnerHTML={{__html: rawBodyContent}}/>
                                </div>
                            </div>
                        </div>
                    </div>
                ] : []}
            </ReactCSSTransitionGroup>
        );
    }
});

const reactModal = function (id, headerTitle, bodyContent, additionalClasses) {
    var div = document.getElementById(id);
    if (_.isNull(div) || _.isUndefined(div)) {
        div = document.createElement('div');
        div.id = id;
        document.body.appendChild(div);
    }
    $(div).empty();
    React.render(<ReactModal headerTitle={headerTitle} bodyContent={bodyContent} additionalClasses={additionalClasses}/>, div);
};