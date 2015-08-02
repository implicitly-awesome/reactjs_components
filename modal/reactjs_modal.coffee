@currentModal = window.currentModal = null

ReactModal = React.createClass
  propTypes:
    headerTitle: React.PropTypes.string,
    bodyContent: React.PropTypes.string,
    additionalClasses: React.PropTypes.object,
    onShow: React.PropTypes.func,
    onHide: React.PropTypes.func
  getInitialState: ->
    show: false
  componentDidMount: ->
    @setState show: true
    key 'esc', @hideModal
    @props.onShow() if @props.onShow
  componentWillUnmount: ->
    key.unbind 'esc', @hideModal
  hideModal: ->
    @setState show: false
    setTimeout (-> $('div.form-modal-errors').html ''), 600
    @props.onHide() if @props.onHide
  render: ->
    rawBodyContent = @props.bodyContent
    ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
    `<ReactCSSTransitionGroup transitionName="show">
        {this.state.show ? [
        <div className='react-modal-container' key={Math.random()}>
            <div className='react-modal'>
                <div className={'react-modal-content '+(this.props.additionalClasses ? this.props.additionalClasses.content : '')}>
                    <div className={'react-modal-header '+(this.props.additionalClasses ? this.props.additionalClasses.header : '')}>
                        <button type='button' className='close' aria-label='Close' onClick={this.hideModal}>
                            <span aria-hidden='true'>×</span>
                        </button>
                        <h4 className={'react-modal-title '+(this.props.additionalClasses ? this.props.additionalClasses.title : '')}>
                            {this.props.headerTitle}
                        </h4>
                    </div>
                    <div className={'react-modal-body '+(this.props.additionalClasses ? this.props.additionalClasses.body : '')}>
                        <span dangerouslySetInnerHTML={{__html: rawBodyContent}}/>
                    </div>
                </div>
            </div>
        </div>
            ] : []}
    </ReactCSSTransitionGroup>`

@reactModal = (containerId, headerTitle = '', bodyContent = '', additionalClasses = {}, onShow = null, onHide = null) ->
  container = document.getElementById(containerId)
  unless container
    container = document.createElement('div')
    container.id = containerId
    document.body.appendChild container
  $(container).empty()
  modal = React.render `<ReactModal headerTitle={headerTitle} bodyContent={bodyContent} additionalClasses={additionalClasses} onShow={onShow} onHide={onHide}/>, container`
  window.currentModal = modal
  modal