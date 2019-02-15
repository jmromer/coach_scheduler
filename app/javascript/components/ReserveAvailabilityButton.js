import React from 'react'
import { PropTypes } from 'prop-types'

const ReserveAvailabilityButton = props =>
  !props.selectedAvailability ? (
    <div />
  ) : (
    <button
      type='button'
      className='btn btn-primary mt-md-2 mb-md-2'
      onClick={props.handleSubmit}
      disabled={props.isLoading}
    >
      Reserve this time slot
    </button>
  )

ReserveAvailabilityButton.propTypes = {
  selectedAvailability: PropTypes.object,
  handleSubmit: PropTypes.func.isRequired,
  isLoading: PropTypes.bool.isRequired
}

export default ReserveAvailabilityButton
