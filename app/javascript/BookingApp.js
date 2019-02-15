import React, { Component } from 'react'
import Select from 'react-select'

import AvailabilitySelect from './components/AvailabilitySelect'
import ReserveAvailabilityButton from './components/ReserveAvailabilityButton'
import FlashMessage from './components/FlashMessage'
import { getCoaches, createAppointment } from './lib/api'

class BookingApp extends Component {
  state = {
    coaches: [],
    selectedAvailability: null,
    selectedCoach: null,
    createdAppointment: null,
    loading: false,
    messages: []
  }

  componentDidMount () {
    this.setState({ loading: true })

    getCoaches().then(({ data }) =>
      this.setState({ loading: false, coaches: data })
    )
  }

  coachOptions = list =>
    list.map(coach => ({ value: coach, label: coach.name }))

  handleCoachSelection = selection => {
    this.setState({ selectedAvailability: null })
    this.setState({ selectedCoach: selection })
  }

  handleAvailabilitySelection = selection => {
    this.setState({ selectedAvailability: selection })
  }

  handleSubmit = event => {
    event.preventDefault()
    this.setState({ loading: true })

    const timeslot = this.state.selectedAvailability.value

    createAppointment(timeslot.id).then(({ data, messages }) =>
      this.setState({
        loading: false,
        createdAppointment: data,
        messages
      })
    )
  }

  render () {
    return (
      <div className='BookingApp'>
        <h1>Book a coaching session</h1>

        {this.state.messages.map((e, i) => (
          <FlashMessage key={i} message={e.message} type={e.type} />
        ))}

        <Select
          options={this.coachOptions(this.state.coaches)}
          onChange={this.handleCoachSelection}
          isLoading={this.state.loading}
          placeholder='Select a coach...'
        />

        <AvailabilitySelect
          selectedCoach={this.state.selectedCoach || {}}
          selectedAvailability={this.state.selectedAvailability}
          handleSelection={this.handleAvailabilitySelection}
          placeholder='Select an appointment time...'
        />

        <ReserveAvailabilityButton
          selectedAvailability={this.state.selectedAvailability}
          handleSubmit={this.handleSubmit}
          isLoading={this.state.loading}
        />

        <div> {this.state.loading ? 'loading...' : ''} </div>
      </div>
    )
  }
}

export default BookingApp
