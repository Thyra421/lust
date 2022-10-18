import { selectHobbies, replaceHobbies } from "../models/hobbies.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getHobbies(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }

    const hobbies = await selectHobbies(query)
    return success(res, hobbies.hobbies)
}

export async function setHobbies(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }
    const newHobbies = { hobbies: req.body }

    await replaceHobbies(query, newHobbies)
    return success(res, "OK")
}