import React, { Component } from 'react'
import Select from 'react-select'
import { PropTypes } from 'prop-types'

const availabilityOptions = list =>
  list.map(availability => ({
    value: availability,
    label: availability.localizedLabel
  }))

const AvailabilitySelect = props => {
  const coach = props.selectedCoach.value || {}

  if (!coach.availabilities) {
    return <div />
  }

  return (
    <Select
      onChange={props.handleSelection}
      options={availabilityOptions(coach.availabilities)}
      placeholder={props.placeholder}
      value={props.selectedAvailability}
    />
  )
}

AvailabilitySelect.propTypes = {
  selectedCoach: PropTypes.object.isRequired,
  selectedAvailability: PropTypes.object,
  handleSelection: PropTypes.func.isRequired,
  placeholder: PropTypes.string.isRequired
}

export default AvailabilitySelect
