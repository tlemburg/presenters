import {VBase} from './base';
import appConfig from '../../config';
import {expandParams} from './action_parameter';
import {encode} from './encode';

// Replaces a given element with the contents of the call to the url.
// parameters are appended.
export class VPosts extends VBase {
    constructor(options, url, params, method, event, root) {
        super(options, root);
        this.url = url;
        this.params = params;
        this.method = method;
        this.event = event;
        this.headers = options.headers;
    }

    call(results) {
        this.clearErrors();
        let errors = this.validate();
        let method = this.method;
        if (errors.length > 0) {
            return new Promise(function(_, reject) {
                results.push({
                    action: 'posts',
                    method: method,
                    statusCode: 400,
                    contentType: 'v/errors',
                    content: errors,
                });
                reject(results);
            });
        }

        // Manually build the FormData.
        // Passing in a <form> element (if available) would skip over
        // unchecked toggle elements, which would be unexpected if the user
        // has specified a value for the toggle's `off_value` attribute.
        const formData = new FormData();

        // NB: `inputValues` will appropriately handle `input_tag`.
        for (const [name, value] of this.inputValues()) {
            formData.append(name, value);
        }

        // Add params from presenter:
        expandParams(results, this.params);

        for (const [name, value] of Object.entries(this.params)) {
            formData.append(name, encode(value));
        }

        // log dupes:
        // TODO: remove me (debug)
        for (const [k, v] of formData) {
            console.log(`${k}: ${v}`);
        }

        }

        const httpRequest = new XMLHttpRequest();
        const url = this.url;
        const callHeaders = this.headers;
        const root = this.root;
        if (!httpRequest) {
            throw new Error(
                'Cannot talk to server! Please upgrade your browser to one that supports XMLHttpRequest.');
        }

        let snackbarCallback = function(contentType, response) {
            const snackbar = root.querySelector('.mdc-snackbar').vComponent;
            if (contentType && contentType.indexOf('application/json') !== -1) {
                const messages = JSON.parse(response).messages;
                if (snackbar && messages && messages.snackbar) {
                    const message = messages.snackbar.join('<br/>');
                    if (message !== '') {
                        snackbar.display(message);
                    }
                }
            }
        };

        return new Promise(function(resolve, reject) {
            httpRequest.onreadystatechange = function(event) {
                if (httpRequest.readyState === XMLHttpRequest.DONE) {
                    const contentType = this.getResponseHeader('content-type');
                    console.log(httpRequest.status + ':' + contentType);
                    if (httpRequest.status >= 200 && httpRequest.status < 300) {
                        results.push({
                            action: 'posts',
                            method: this.method,
                            statusCode: httpRequest.status,
                            contentType: contentType,
                            content: httpRequest.responseText,
                            responseURL: httpRequest.responseURL,
                        });
                        snackbarCallback(contentType,
                            httpRequest.responseText);
                        resolve(results);
                        // Response is an html error page
                    }
                    else if (contentType && contentType.indexOf('text/html') !==
                        -1) {
                        root.open(contentType);
                        root.write(httpRequest.responseText);
                        root.close();
                        results.push({
                            action: 'posts',
                            method: this.method,
                            statusCode: httpRequest.status,
                            contentType: contentType,
                            content: httpRequest.responseText,
                            responseURL: httpRequest.responseURL,
                        });
                        resolve(results);
                    }
                    else {
                        results.push({
                            action: 'posts',
                            method: this.method,
                            statusCode: httpRequest.status,
                            contentType: contentType,
                            content: httpRequest.responseText,
                        });
                        reject(results);
                    }
                }
            };
            // Set up our request
            httpRequest.open(method, url);

            const configHeaders = appConfig.get('request.headers.POST', {});

            for (const [key, value] of Object.entries(configHeaders)) {
                httpRequest.setRequestHeader(key, value);
            }

            if (callHeaders) {
                for (const [key, value] of Object.entries(callHeaders)) {
                    httpRequest.setRequestHeader(key, value);
                }
            }

            // Send our FormData object; HTTP headers are set automatically
            httpRequest.send(formData);
        });
    }

    isForm() {
        var parentElement = this.parentElement();
        return parentElement && parentElement.elements;
    }

    form() {
        if (this.isForm()) {
            return this.parentElement();
        }
        return null;
    }
}
