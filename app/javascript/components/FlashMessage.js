import React, { Component } from 'react'
import { Alert } from 'reactstrap'

class FlashMessage extends Component {
  state = {
    visible: true
  }

  onDismiss = () => {
    this.setState({ visible: false })
  }

  getMessageType = () => {
    const mapping = { alert: 'danger', notice: 'info' }
    return mapping[this.props.type] || 'warning'
  }

  render () {
    return (
      <Alert
        color={this.getMessageType()}
        isOpen={this.state.visible}
        toggle={this.onDismiss}
      >
        {this.props.message}
      </Alert>
    )
  }
}

export default FlashMessage
