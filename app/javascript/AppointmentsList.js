import React, { Component } from 'react'
import { Table } from 'reactstrap'

import FlashMessage from './components/FlashMessage'
import { getAppointments } from './lib/api'

const Appointment = props => (
  <tr>
    <td>{props.coach.name}</td>
    <td>{props.localizedLabel}</td>
  </tr>
)

class AppointmentsList extends Component {
  state = {
    appointments: [],
    loading: false,
    messages: []
  }

  componentDidMount () {
    this.setState({ loading: true })

    getAppointments().then(({ data }) =>
      this.setState({ loading: false, appointments: data })
    )
  }

  render () {
    return (
      <div className='AppointmentsList'>
        <h1>My Appointments</h1>

        {this.state.messages.map((e, i) => (
          <FlashMessage key={i} message={e.message} type={e.type} />
        ))}

        <Table>
          <thead>
            <tr>
              <th>Coach</th>
              <th>Meeting time (local)</th>
            </tr>
          </thead>

          <tbody>
            {this.state.appointments.map((e, i) => (
              <Appointment key={i} {...e} />
            ))}
          </tbody>
        </Table>

        <div> {this.state.loading ? 'loading...' : ''} </div>
      </div>
    )
  }
}

export default AppointmentsList
