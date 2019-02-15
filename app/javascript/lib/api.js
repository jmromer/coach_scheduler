const baseUrl = '/graphql'
const csrfToken = document
  .querySelector('meta[name=csrf-token]')
  .getAttribute('content')

const jsonHeaders = {
  Accept: 'application/json',
  'Content-Type': 'application/json',
  'X-CSRF-Token': csrfToken,
  credentials: 'same-origin'
}

const getCoaches = () => {
  const query = `
    {
       coaches {
         id
         name
         availabilities {
           id
           localizedLabel
         }
       }
    }
  `
  return window
    .fetch(baseUrl, {
      method: 'POST',
      headers: jsonHeaders,
      body: JSON.stringify({ query: query })
    })
    .then(resp => resp.json())
    .then(json => ({ data: json.data.coaches }))
}

const getAppointments = () => {
  const query = `
    {
       appointments {
           id
           localizedLabel
           coach {
               name
           }
       }
    }
  `
  return window
    .fetch(baseUrl, {
      method: 'POST',
      headers: jsonHeaders,
      body: JSON.stringify({ query: query })
    })
    .then(resp => resp.json())
    .then(json => ({ data: json.data.appointments }))
}

const createAppointment = id => {
  const query = `
    mutation {
       reserveAvailability(input: { id: ${id} }) {
         appointment {
           id
           localizedLabel
           coach {
               name
           }
         }
         errors
       }
    }
  `
  return window
    .fetch(baseUrl, {
      method: 'POST',
      headers: jsonHeaders,
      body: JSON.stringify({ query: query })
    })
    .then(resp => resp.json())
    .then(json => {
      const data = json.data.reserveAvailability
      const appointment = data.appointment
      const messages = data.errors.map(err => ({ type: 'error', message: err }))

      if (appointment) {
        messages.push({
          type: 'notice',
          message: `You're booked to speak with ${appointment.coach.name}
                    on ${appointment.localizedLabel}!`
        })
      }

      return { data: appointment, messages }
    })
}

export { getAppointments, getCoaches, createAppointment }
