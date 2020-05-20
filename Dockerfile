# Dockerfile for ubyssey-site image
# Contains the two basic repos that Ubyssey.ca needs to run
#  This is unlikely to be a permanent solution.
#  Ideally, we'll have a build/deployment process in place that can containerize Dispatch and the Ubyssey dispatch theme on their own
# This same image can be deployed to many different environments, and using FROM, we will add to it to set up a development environment, production environment...

#Use this Python 3.8.2-buster image because there's so much to be installed on this container, version ought to be explicit
FROM python:3.8.2-buster
ENV PYTHONUNBUFFERED 1
RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y git
  
# Clone the relevant repos
RUN git clone https://github.com/keeganland/ubyssey.ca.git/ /workspaces/ubyssey.ca/
RUN git clone https://github.com/keeganland/dispatch.git/ /workspaces/dispatch/
  
# Set up the Ubyssey.ca Theme repo's dependencies on the container
RUN pip install -r /workspaces/ubyssey.ca/requirements.txt

# Dev settings. Maybe need to change this
RUN cp -r /workspaces/ubyssey.ca/_settings/settings-local.py /workspaces/ubyssey.ca/ubyssey/settings.py

#ENTRYPOINT ["/workspaces/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]